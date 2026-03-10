# celso.is

A polymath content hub built with Rails, featuring semantic URLs like `celso.is/exploring`, `celso.is/experimenting`, and smart redirects.

## 🚀 Features

### Content Structure
- **Categories**: exploring, experimenting, learning, thinking
- **Static Pages**: a-dev, a-mindhacker, an-explorer  
- **Smart Redirects**: Create short URLs like `/here` → `/contact`
- **Rich Text Editor**: Trix with drag-drop image uploads
- **SEO Ready**: Meta tags, friendly URLs, sitemap

### Admin Panel
- Full CRUD for Posts, Pages, Categories, Redirects
- Rich text editing with image uploads
- Draft/publish workflow
- HTTP Basic Auth protection

### Tech Stack
- **Ruby**: 3.3.10
- **Rails**: 8.1.2
- **Database**: PostgreSQL (with Solid Queue for jobs)
- **CSS**: Tailwind CSS
- **JavaScript**: Hotwire (Turbo + Stimulus)
- **Deployment**: Kamal + Docker
- **Hosting**: Hetzner Cloud

## 🛠️ Local Development

### Prerequisites
- Ruby 3.3.10 (via rbenv)
- PostgreSQL
- Node.js (for Tailwind)

### Setup

```bash
# Clone and navigate
cd celso

# Install dependencies
bundle install

# Setup database
bin/rails db:create db:migrate db:seed

# Start server
bin/rails server

# Visit http://localhost:3000
```

### Admin Access
- URL: http://localhost:3000/admin
- Username: `admin`
- Password: `changeme123` (change this before deploying!)

## 📦 Deployment

### Phase 1: Server Setup (Already Done)
✅ Hetzner CX33 server provisioned  
✅ Docker installed  
✅ Firewall configured  
✅ Volume mounted at `/var/uploads`  
✅ DNS configured for celso.is

### Phase 2: Pre-Deployment Checklist

1. **Change Admin Password**
   ```ruby
   # app/controllers/admin/base_controller.rb
   # Change: password == "changeme123"
   # To: password == "your_secure_password"
   ```

2. **Create GitHub Personal Access Token**
   - Go to: https://github.com/settings/tokens
   - Generate new token (classic)
   - Scopes: `read:packages`, `write:packages`, `delete:packages`
   - Copy the token

3. **Create Environment File**
   Create `.env.production`:
   ```bash
   POSTGRES_USER=celso
   POSTGRES_PASSWORD=your_secure_postgres_password
   POSTGRES_DB=celso_production
   POSTGRES_HOST=celso-is-postgres
   
   KAMAL_REGISTRY_USERNAME=your_github_username
   KAMAL_REGISTRY_PASSWORD=ghp_your_github_token
   ```

4. **Configure Kamal**
   Update `.kamal/deploy.yml` with your server IP

### Phase 3: Deploy

```bash
# First time setup
kamal setup

# Deploy updates
kamal deploy

# Check status
kamal status

# View logs
kamal logs --follow
```

## 📝 Content Management

### Creating Content

1. **Categories** (via Admin)
   - Create: exploring, experimenting, learning, thinking
   - Each category gets its own URL: `/exploring`

2. **Posts** (via Admin)
   - Select category
   - Write content in rich text editor
   - Set publish date and status
   - URL: `/exploring/post-title`

3. **Pages** (via Admin)
   - Create static pages like `/a-dev`
   - Use for permanent content

4. **Redirects** (via Admin)
   - Source: `here`
   - Destination: `/contact` or `https://external.com`
   - Creates: `celso.is/here`

### URL Structure

```
celso.is/                    # Homepage with 3 boxes
celso.is/exploring           # Category page
celso.is/exploring/sleep     # Individual post
celso.is/a-dev               # Static page
celso.is/here                # Smart redirect
```

## 🔧 Customization

### Styling
- Edit `app/assets/stylesheets/custom.css`
- Tailwind classes throughout views
- Customize colors in `config/tailwind.config.js`

### Homepage Boxes
Edit `app/views/home/index.html.erb` to:
- Change box labels
- Update colors
- Modify layout

### SEO
Edit `app/views/layouts/application.html.erb`:
- Update default meta description
- Add Open Graph tags
- Customize page titles

## 🧪 Testing

```bash
# Run all tests
bin/rails test

# Run specific test
bin/rails test test/models/post_test.rb

# Run system tests
bin/rails test:system
```

## 📊 Monitoring

### Local Monitoring
- Health check: `/up`
- Rails logs: `tail -f log/development.log`

### Production Monitoring (UptimeRobot)
1. Sign up: https://uptimerobot.com
2. Add monitor: `https://celso.is/up`
3. Set interval: 5 minutes

## 🔄 Backup Strategy

Database and uploads are backed up to `/var/backups/celso-is/`

Manual backup:
```bash
# SSH to your server (see your Kamal config for IP)
ssh YOUR_USER@YOUR_SERVER_IP
/home/YOUR_USER/backup.sh
```

## 🚨 Troubleshooting

### Common Issues

**Assets not loading:**
```bash
bin/rails assets:precompile
```

**Database connection error:**
```bash
bin/rails db:create db:migrate
```

**Docker build fails:**
```bash
# Test locally
docker build .
```

### Getting Help

1. Check Rails logs: `kamal logs --follow`
2. Check server: `ssh YOUR_USER@YOUR_SERVER_IP` (replace with your actual server IP)
3. Rails console: `kamal console`

## 📄 License

Private - All rights reserved.

## 🙏 Credits

Built with:
- Rails 8
- Tailwind CSS
- Hotwire
- Kamal
- Hetzner Cloud

---

**Ready to deploy?** Follow the deployment checklist above!
