import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/voice_command.dart';
import '../services/voice_service.dart';
import '../services/command_processor.dart';
import '../services/command_analyzer.dart';

// Voice Service Provider
final voiceServiceProvider = Provider<VoiceService>((ref) {
  return VoiceService();
});

// Command Processor Provider
final commandProcessorProvider = Provider<CommandProcessor>((ref) {
  return CommandProcessor();
});

// Command Analyzer Provider
final commandAnalyzerProvider = Provider<CommandAnalyzer>((ref) {
  return CommandAnalyzer();
});

// Voice Commands State
class VoiceCommandsState {

  const VoiceCommandsState({
    this.isListening = false,
    this.isProcessing = false,
    this.recentCommands = const [],
    this.lastRecognizedText,
    this.lastResponse,
    this.isInitialized = false,
    this.error,
  });
  final bool isListening;
  final bool isProcessing;
  final List<VoiceCommand> recentCommands;
  final String? lastRecognizedText;
  final String? lastResponse;
  final bool isInitialized;
  final String? error;

  VoiceCommandsState copyWith({
    bool? isListening,
    bool? isProcessing,
    List<VoiceCommand>? recentCommands,
    String? lastRecognizedText,
    String? lastResponse,
    bool? isInitialized,
    String? error,
  }) {
    return VoiceCommandsState(
      isListening: isListening ?? this.isListening,
      isProcessing: isProcessing ?? this.isProcessing,
      recentCommands: recentCommands ?? this.recentCommands,
      lastRecognizedText: lastRecognizedText ?? this.lastRecognizedText,
      lastResponse: lastResponse ?? this.lastResponse,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
    );
  }
}

// Voice Commands Notifier
class VoiceCommandsNotifier extends StateNotifier<VoiceCommandsState> {

  VoiceCommandsNotifier(
    this._voiceService,
    this._commandProcessor,
    this._commandAnalyzer,
  ) : super(const VoiceCommandsState());
  final VoiceService _voiceService;
  final CommandProcessor _commandProcessor;
  final CommandAnalyzer _commandAnalyzer;

  // Initialize voice services
  Future<void> initialize() async {
    try {
      state = state.copyWith(isProcessing: true);

      final initialized = await _voiceService.initialize();

      state = state.copyWith(isInitialized: initialized, isProcessing: false);
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: 'فشل في تهيئة الخدمات الصوتية: ${e.toString()}',
      );
    }
  }

  // Start listening for voice commands
  Future<void> startListening() async {
    if (!state.isInitialized) {
      await initialize();
    }

    try {
      state = state.copyWith(isListening: true);

      // Set up callbacks
      _voiceService.onRecognitionResult = _processVoiceInput;

      await _voiceService.startListening();
    } catch (e) {
      state = state.copyWith(
        isListening: false,
        error: 'فشل في بدء الاستماع: ${e.toString()}',
      );
    }
  }

  // Stop listening
  Future<void> stopListening() async {
    try {
      await _voiceService.stopListening();
      state = state.copyWith(isListening: false);
    } catch (e) {
      state = state.copyWith(
        isListening: false,
        error: 'فشل في إيقاف الاستماع: ${e.toString()}',
      );
    }
  }

  // Process voice input
  Future<void> _processVoiceInput(String recognizedText) async {
    try {
      state = state.copyWith(
        isProcessing: true,
        lastRecognizedText: recognizedText,
      );

      // Analyze the command first
      final analysis = _commandAnalyzer.analyzeCommand(recognizedText);

      // Create voice command object
      final voiceCommand = VoiceCommand(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        originalText: recognizedText,
        processedText: analysis.processedText,
        type: analysis.type,
        confidence: analysis.confidence,
        parameters: analysis.parameters,
        createdAt: DateTime.now(),
      );

      // Process the command
      final result = await _commandProcessor.processCommand(voiceCommand);

      // Update recent commands
      final updatedCommands = [result, ...state.recentCommands]
          .take(20) // Keep only last 20 commands
          .toList();

      // Speak response if available
      if (result.response != null && result.response!.isNotEmpty) {
        await _voiceService.speak(result.response!);
      }

      state = state.copyWith(
        isProcessing: false,
        recentCommands: updatedCommands,
        lastResponse: result.response,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: 'فشل في معالجة الأمر الصوتي: ${e.toString()}',
      );
    }
  }

  // Clear recent commands
  void clearRecentCommands() {
    state = state.copyWith(recentCommands: []);
  }

  // Clear error
  void clearError() {
    state = state.copyWith();
  }

  // Check if speech recognition is available
  Future<bool> checkSpeechAvailability() async {
    return _voiceService.isInitialized;
  }

  // Toggle continuous listening mode
  Future<void> toggleListening() async {
    if (state.isListening) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  // Dispose resources
  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }
}

// Voice Commands Provider
final voiceCommandsProvider =
    StateNotifierProvider<VoiceCommandsNotifier, VoiceCommandsState>((ref) {
      final voiceService = ref.watch(voiceServiceProvider);
      final commandProcessor = ref.watch(commandProcessorProvider);
      final commandAnalyzer = ref.watch(commandAnalyzerProvider);

      return VoiceCommandsNotifier(
        voiceService,
        commandProcessor,
        commandAnalyzer,
      );
    });

// Helper Providers
final isListeningProvider = Provider<bool>((ref) {
  return ref.watch(voiceCommandsProvider).isListening;
});

final isProcessingProvider = Provider<bool>((ref) {
  return ref.watch(voiceCommandsProvider).isProcessing;
});

final recentCommandsProvider = Provider<List<VoiceCommand>>((ref) {
  return ref.watch(voiceCommandsProvider).recentCommands;
});

final lastRecognizedTextProvider = Provider<String?>((ref) {
  return ref.watch(voiceCommandsProvider).lastRecognizedText;
});

final voiceCommandsErrorProvider = Provider<String?>((ref) {
  return ref.watch(voiceCommandsProvider).error;
});
