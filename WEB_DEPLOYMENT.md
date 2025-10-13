# 🌐 Quick Web Deployment Guide

This is a quick reference guide for deploying the Habit Tracker web app. For complete details, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md).

## 🚀 Deploy to Netlify (Easiest)

### Method 1: Drag & Drop (No CLI needed)

1. Build locally:
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter build web --release --web-renderer canvaskit
   ```

2. Go to [netlify.com](https://app.netlify.com)
3. Drag the `build/web` folder to Netlify
4. Done! Your site is live 🎉

### Method 2: Git Integration (Automatic deployments)

1. Push code to GitHub
2. Go to [netlify.com](https://app.netlify.com) → "New site from Git"
3. Connect your repo
4. Deploy settings are auto-detected from `netlify.toml`
5. Every push to main will auto-deploy!

## 🔷 Deploy to Vercel

### Method 1: Git Integration (Recommended)

1. Push code to GitHub
2. Go to [vercel.com](https://vercel.com) → "New Project"
3. Import your repository
4. Settings are auto-detected from `vercel.json`
5. Deploy!

### Method 2: CLI

```bash
npm install -g vercel
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --release
vercel --prod
```

## 🔥 Deploy to Firebase Hosting

```bash
# First time setup
npm install -g firebase-tools
firebase login
firebase init hosting
# Select: build/web as public directory
# Configure as single-page app: Yes

# Deploy
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --release
firebase deploy --only hosting
```

## 📦 What's Included

✅ `netlify.toml` - Netlify configuration  
✅ `vercel.json` - Vercel configuration  
✅ Enhanced `web/index.html` with SEO meta tags  
✅ CI/CD workflow for automated builds  
✅ Web build job in `.github/workflows/ci.yml`  
✅ Dedicated deploy workflow in `.github/workflows/deploy-web.yml`

## 🎯 Quick Tips

- **First deployment?** Use Netlify drag & drop - it's the fastest!
- **Need automatic deployments?** Connect Git integration on Netlify or Vercel
- **Want a custom domain?** All platforms support it (usually free)
- **Build failing?** Check that you ran `dart run build_runner build` first

## 📱 Test Your Deployment

After deploying, test:
- ✅ App loads without errors
- ✅ All features work (habits, tracking, etc.)
- ✅ Responsive design on mobile
- ✅ Works in different browsers

## 🆘 Quick Troubleshooting

**White screen after deploy?**
- Check browser console for errors
- Verify all assets are in pubspec.yaml
- Try rebuilding: `flutter clean && flutter build web`

**Build fails on platform?**
- Ensure `netlify.toml` or `vercel.json` is in root
- Check build logs for specific error
- Verify Flutter version matches (3.9.2)

## 📊 Platform Comparison

| Platform | Free Tier | Setup Time | Auto Deploy |
|----------|-----------|------------|-------------|
| Netlify | 100GB/month | 2 min | ✅ |
| Vercel | 100GB/month | 2 min | ✅ |
| Firebase | 10GB/month | 5 min | ✅ |

## 🔗 Links

- [Full Deployment Guide](DEPLOYMENT_GUIDE.md)
- [Netlify Docs](https://docs.netlify.com/)
- [Vercel Docs](https://vercel.com/docs)
- [Firebase Docs](https://firebase.google.com/docs/hosting)

---

**Need help?** Check [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed instructions!
