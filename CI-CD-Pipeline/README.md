# My Project

A sample project demonstrating GitHub Actions CI/CD pipeline.

## Features

- Automated testing with Jest
- Build process with Webpack
- Deployment to GitHub Pages
- Multi-Node.js version testing

## GitHub Actions Workflow

The workflow (`/.github/workflows/main.yml`) includes:

1. **Testing & Building**: Runs on Node.js 18.x and 20.x
   - Installs dependencies
   - Runs tests
   - Builds the project
   - Uploads build artifacts

2. **Deployment**: Deploys to GitHub Pages (only on main branch pushes)
   - Builds the project
   - Deploys to GitHub Pages using the built files

## Setup Instructions

1. **Enable GitHub Pages**:
   - Go to your repository settings
   - Navigate to "Pages" section
   - Set source to "GitHub Actions"

2. **Push to main branch** to trigger the workflow

3. **Monitor the workflow**:
   - Check the "Actions" tab in your repository
   - View logs and build status

## Local Development

```bash
# Install dependencies
npm install

# Run tests
npm test

# Build project
npm run build

# Start development server
npm run dev
```

## Deployment Options

The workflow is configured for GitHub Pages, but you can easily modify it for other platforms:

### Netlify
Replace the deploy step with:
```yaml
- name: Deploy to Netlify
  uses: nwtgck/actions-netlify@v2.0
  with:
    publish-dir: './dist'
    production-branch: main
  env:
    NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
    NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

### AWS S3
Replace the deploy step with:
```yaml
- name: Deploy to S3
  uses: jakejarvis/s3-sync-action@master
  with:
    args: --delete
  env:
    AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    SOURCE_DIR: 'dist'
```