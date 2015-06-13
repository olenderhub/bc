class Article
  attr_reader :title, :body, :author, :created_at
  attr_accessor :likes, :dislikes

  def initialize (title, body, author = nil)
  	@title = title
  	@body = body
  	@author = author
  	@created_at = Time.now
  	@likes = 0
  	@dislikes = 0
  end

  def like!
    @likes += 1
  end

  def dislike!
    @dislikes += 1
  end

  def points
    @likes-@dislikes
  end

  def votes
    @votes = @likes+@dislikes
  end

  def long_lines
    body.lines.select { |line|  line.length>80  }
  end

  def length
    body.length
  end

  def truncate(limit)
    body.length > limit ? body[0..limit-4] + "..." : body
  end

  def contain?(str)
    !body.index(str).nil?
  end
end

class ArticlesFileSystem
  attr_reader :dir_name

  def initialize (dir_name)
    @dir_name = dir_name
  end

  def save(articles)
    articles.each do |article|
      my_file = File.new(@dir_name + "/" + article.title.downcase.sub(" ","_") + ".article", "w+")
      my_file.write([article.author, article.likes.to_s, article.dislikes.to_s, article.body].join("||"))
      my_file.close
    end
  end

  def load
    Dir.glob(dir_name + "/*.article").map do |filename|
      contents = File.read(filename).split("||")
      title = File.basename(filename, ".article").capitalize.sub("_"," ")
      article = Article.new(title, contents[3], contents[0])
      article.likes = contents[1].to_i
      article.dislikes = contents[2].to_i
      article
    end
  end
end

class WebPage
  class NoArticlesFound < StandardError
  end

  attr_reader :articles

  def initialize (dir_name = "/")
    @dir_name = dir_name
    load
  end

  def load
    @articles = ArticlesFileSystem.new(@dir_name).load
  end

  def save
    ArticlesFileSystem.new(@dir_name).save(@articles)
  end

  def new_article(title, body, author = nil)
    articles << Article.new(title, body, author)
  end

  def longest_articles
    articles.sort_by{|article| article.length}.reverse
  end

  def best_articles
    articles.sort_by{|article| article.points}.reverse
  end

  def worst_articles
    best_articles.reverse
  end

  def best_article
    raise NoArticlesFound if articles.empty?
    best_articles.first
  end

  def worst_article
    raise NoArticlesFound if articles.empty?
    best_articles.last
  end

  def most_controversial_articles
    articles.sort_by{|article| article.votes}.reverse
  end

  def votes
    articles.inject(0) { |sum, article| sum + article.votes}
  end

  def authors
    articles.map { |article| article.author }.uniq
  end

  def authors_statistics
    h = Hash.new(0)
    articles.each { |article| h[article.author] += 1}
    h
  end

  def best_author
    authors_statistics.max_by {|k,v| v}.first
  end

  def search(query)
    articles.select { |article| article.contain?(query) }
  end
end
