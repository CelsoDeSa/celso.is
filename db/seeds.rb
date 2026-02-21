# Pages with category flag
puts "Creating pages and categories..."

pages_data = [
  {
    title: "Exploring",
    slug: "exploring",
    acts_as_category: true,
    category_description: "Deep dives into topics I'm curious about - from money and investing to health, systems, and everything in between.",
    published: true,
    position: 1
  },
  {
    title: "Experimenting",
    slug: "experimenting",
    acts_as_category: true,
    category_description: "N=1 trials, biohacking, quantified-self projects. What happens when I try X for 30 days?",
    published: true,
    position: 2
  },
  {
    title: "Learning",
    slug: "learning",
    acts_as_category: true,
    category_description: "Beginner-to-intermediate reflections on skills I'm actively developing. Openly iterative.",
    published: true,
    position: 3
  },
  {
    title: "Thinking",
    slug: "thinking",
    acts_as_category: true,
    category_description: "Essays, mental models, and philosophy. More abstract explorations of how things work.",
    published: true,
    position: 4
  },
  {
    title: "a dev",
    slug: "a-dev",
    acts_as_category: false,
    content: "<h2>Code, Systems, and Technical Experiments</h2>
    <p>Welcome to my developer corner. This is where I share:</p>
    <ul>
      <li>Coding projects and experiments</li>
      <li>System architecture and design patterns</li>
      <li>DevOps and deployment strategies</li>
      <li>Tool recommendations and workflows</li>
    </ul>
    <p>Currently exploring: Rails, Hotwire, and modern deployment with Kamal.</p>",
    published: true,
    position: 5
  },
  {
    title: "a mindhacker",
    slug: "a-mindhacker",
    acts_as_category: false,
    content: "<h2>Biohacking, Optimization, and Mental Models</h2>
    <p>I believe the mind and body are systems that can be optimized. Here I document:</p>
    <ul>
      <li>Biohacking experiments (sleep, fasting, supplements)</li>
      <li>Cognitive enhancement techniques</li>
      <li>Mental models for better thinking</li>
      <li>Productivity systems and habits</li>
    </ul>
    <p>Always experimenting. Always iterating.</p>",
    published: true,
    position: 6
  },
  {
    title: "an explorer",
    slug: "an-explorer",
    acts_as_category: false,
    content: "<h2>Money, Health, Ideas, and Everything In Between</h2>
    <p>This is my digital commonplace book - a place for polymathic curiosity:</p>
    <ul>
      <li>Personal finance and investing notes</li>
      <li>Health and wellness discoveries</li>
      <li>Interesting ideas and concepts</li>
      <li>Book notes and learning summaries</li>
    </ul>
    <p>Exploring the world, one rabbit hole at a time.</p>",
    published: true,
    position: 7
  }
]

pages_data.each do |page_data|
  Page.find_or_create_by!(slug: page_data[:slug]) do |page|
    page.title = page_data[:title]
    page.acts_as_category = page_data[:acts_as_category]
    page.category_description = page_data[:category_description] if page_data[:acts_as_category]
    page.content = page_data[:content] if page_data[:content]
    page.published = page_data[:published]
    page.position = page_data[:position]
    page.meta_description = "#{page_data[:title]} - Celso's corner of the internet"
  end
end

# Sample Posts
puts "Creating sample posts..."

exploring = Page.find_by!(slug: "exploring")
experimenting = Page.find_by!(slug: "experimenting")
learning = Page.find_by!(slug: "learning")

posts = [
  {
    page: exploring,
    title: "What I'm Exploring Right Now",
    content: "<p>This is a placeholder post to show how the site works. Replace this with your actual content!</p>
    <p>Write in the rich text editor, drag and drop images, and create beautiful content.</p>",
    published: true,
    published_at: Time.current,
    position: 1
  },
  {
    page: experimenting,
    title: "My First 30-Day Experiment",
    content: "<p>Another placeholder post. Delete this and start writing your own experiments!</p>",
    published: true,
    published_at: Time.current - 1.day,
    position: 1
  },
  {
    page: learning,
    title: "Learning in Public: Why I Started This Site",
    content: "<p>This post explains why I decided to build celso.is and what I hope to achieve.</p>
    <p>Replace this with your own story!</p>",
    published: true,
    published_at: Time.current - 2.days,
    position: 1
  }
]

posts.each do |post_data|
  Post.find_or_create_by!(title: post_data[:title]) do |post|
    post.page = post_data[:page]
    post.content = post_data[:content]
    post.published = post_data[:published]
    post.published_at = post_data[:published_at]
    post.position = post_data[:position]
  end
end

# Sample Redirects
puts "Creating sample redirects..."

redirects = [
  { source: "github", destination: "https://github.com", active: true },
  { source: "twitter", destination: "https://twitter.com", active: true }
]

redirects.each do |redirect_data|
  Redirect.find_or_create_by!(source: redirect_data[:source]) do |redirect|
    redirect.destination = redirect_data[:destination]
    redirect.active = redirect_data[:active]
  end
end

puts "Seed data created successfully!"
puts ""
puts "You can now:"
puts "- Visit the homepage at http://localhost:3000"
puts "- Access admin at http://localhost:3000/admin"
puts "- Login with username: admin and password: changeme123"
