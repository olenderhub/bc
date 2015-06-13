require 'minitest/autorun'
require './example'
require "tmpdir"

class ArticleTest < Minitest::Test

  def setup
    @article = Article.new("title", "body", "author")
    @article2 = Article.new("title", "t" * 79 + "\n" + "k" * 80 + "\n" + "z" * 81)
  end

  def test_initialization
    assert_equal "title", @article.title
    assert_equal "body", @article.body
    assert_equal "author", @article.author
    assert_in_delta Time.now, @article.created_at, 0.5
    assert_equal 0, @article.likes
    assert_equal 0, @article.dislikes
  end

  def test_initialization_with_anonymous_author
    assert_equal nil, @article2.author
  end

  def test_liking
    2.times{@article.like!}
    assert_equal 2, @article.likes
  end

  def test_disliking
    2.times{@article.dislike!}
    assert_equal 2, @article.dislikes
  end

  def test_points
    @article2.likes = 5
    @article2.dislikes = 3
    assert_equal 2, @article2.points
  end

  def test_long_lines
    assert_equal ["k" * 80 + "\n","z" * 81], @article2.long_lines
  end

  def test_truncate
    assert_equal "ttttttttttttttttt...", @article2.truncate(20)
  end

  def test_truncate_when_limit_is_longer_then_body
    assert_equal @article2.body, @article2.truncate(1000)
  end

  def test_truncate_when_limit_is_same_as_body_length
     assert_equal @article2.body, @article2.truncate(320)
  end

  def test_length
    assert_equal 4, @article.length
  end

  def test_votes
    @article2.likes = 5
    @article2.dislikes = 3
    assert_equal 8, @article2.votes
  end

  def test_contain
    assert @article2.contain?("t")
    refute @article2.contain?("a")
    assert @article2.contain?(/t/)
    refute @article2.contain?("()")
  end
end

class ArticlesFileSystemTest < Minitest::Test

  def setup
    @dir = Dir.mktmpdir
    @fs = ArticlesFileSystem.new(@dir)
    @article = Article.new("title", "body", "author")
    @article2 = Article.new("title2", "body", "author")
    @articles = [@article, @article2]
  end

  def test_saving
    @fs.save(@articles)
    assert_equal "author||0||0||body", File.read(@dir + "/title.article")
    assert_equal "author||0||0||body", File.read(@dir + "/title2.article")
  end

  def test_loading
    File.write(@dir + "/title3.article", "author1||1||2||body1")
    File.write(@dir + "/title4.article", "author2||3||4||body2")
    File.write(@dir + "/title4", "author2||3||4||body2")

    articles = @fs.load.sort_by(&:title)

    assert_equal ["author1", "author2"], articles.map {|x| x.author}
    assert_equal ["Title3", "Title4"], articles.map {|x| x.title}
    assert_equal ["body1", "body2"], articles.map {|x| x.body}
    assert_equal [1, 3], articles.map {|x| x.likes}
    assert_equal [2, 4], articles.map {|x| x.dislikes}
  end
end

class WebPageTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir
    @dir2 = Dir.mktmpdir

    File.write("#{@dir}/art_1.article", "Author 1||4||5||Short body")
    File.write("#{@dir}/art_2.article", "Author 1||3||1||Long long body")
    File.write("#{@dir}/art_3.article", "Author 2||10||5||Body")

    @webpage = WebPage.new(@dir)
    @webpage_empty = WebPage.new(@dir2)
  end

  def test_new_without_anything_to_load
    webpage = WebPage.new

    assert_empty webpage.articles
  end

  def test_new_article
    @webpage.new_article("title1", "body1")

    assert_equal 4, @webpage.articles.count
    refute File.exist?(@dir + "/title1.article")
  end

  def test_longest_articles
    assert_equal ['Art 2', 'Art 1', 'Art 3'], @webpage.longest_articles.map(&:title)
  end

  def test_best_articles
    assert_equal ['Art 3', 'Art 2', 'Art 1'], @webpage.best_articles.map(&:title)
  end

  def test_best_article
    assert_equal "Art 3", @webpage.best_article.title
  end

  def test_best_article_exception_when_no_articles_can_be_found
    assert_raises(WebPage::NoArticlesFound) {@webpage_empty.best_article}
  end

  def test_worst_articles
    assert_equal ['Art 1', 'Art 2', 'Art 3'], @webpage.worst_articles.map(&:title)
  end

  def test_worst_article
    assert_equal "Art 1", @webpage.worst_article.title
  end

  def test_worst_article_exception_when_no_articles_can_be_found
    assert_equal [], @webpage_empty.worst_articles
  end

  def test_most_controversial_articles
    assert_equal ['Art 3', 'Art 1', 'Art 2'], @webpage.most_controversial_articles.map(&:title)
  end

  def test_votes
    assert_equal 28, @webpage.votes
  end

  def test_authors
    assert_equal ["Author 1", "Author 2"], @webpage.authors
  end

  def test_authors_statistics
    assert_equal ({"Author 1"=>2, "Author 2"=>1}), @webpage.authors_statistics
  end

  def test_best_author
    assert_equal "Author 1", @webpage.best_author
  end

  def test_search
    assert_equal 1, @webpage.search("long").size
    assert_equal 2, @webpage.search("body").size
  end
end
