# Categories
puts "Creating categories..."

categories = {
  "exploring" => "Deep dives into topics I'm curious about - from money and investing to health, systems, and everything in between.",
  "experimenting" => "N=1 trials, biohacking, quantified-self projects. What happens when I try X for 30 days?",
  "learning" => "Beginner-to-intermediate reflections on skills I'm actively developing. Openly iterative.",
  "thinking" => "Essays, mental models, and philosophy. More abstract explorations of how things work."
}

categories.each_with_index do |(name, description), index|
  Category.find_or_create_by!(name: name.humanize) do |category|
    category.description = description
    category.position = index + 1
  end
end

# Pages
puts "Creating pages..."

pages = [
  {
    title: "a dev",
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
    position: 1
  },
  {
    title: "a mindhacker",
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
    position: 2
  },
  {
    title: "an explorer",
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
    position: 3
  }
]

pages.each do |page_data|
  Page.find_or_create_by!(title: page_data[:title]) do |page|
    page.content = page_data[:content]
    page.published = page_data[:published]
    page.position = page_data[:position]
    page.meta_description = "#{page_data[:title]} - Celso's corner of the internet"
  end
end

# Sample Posts
puts "Creating sample posts..."

exploring = Category.find_by!(slug: "exploring")
experimenting = Category.find_by!(slug: "experimenting")
learning = Category.find_by!(slug: "learning")

posts = [
  {
    category: exploring,
    title: "What I'm Exploring Right Now",
    content: "<p>This is a placeholder post to show how the site works. Replace this with your actual content!</p>
    <p>Write in the rich text editor, drag and drop images, and create beautiful content.</p>",
    published: true,
    published_at: Time.current,
    position: 1
  },
  {
    category: experimenting,
    title: "My First 30-Day Experiment",
    content: "<p>Another placeholder post. Delete this and start writing your own experiments!</p>",
    published: true,
    published_at: Time.current - 1.day,
    position: 1
  },
  {
    category: learning,
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
    post.category = post_data[:category]
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
puts "- Login with username: admin and password from Rails credentials"
