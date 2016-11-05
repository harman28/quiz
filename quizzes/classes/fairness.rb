require 'statsample'
require 'statsample/bivariate'
require 'statsample/bivariate/pearson'

class FairnessCheck

  ##
  # This seemed to fit the use case
  # https://en.wikipedia.org/wiki/Pearson_product-moment_correlation_coefficient
  def self.pearson_product_moment_correlation_coefficient strengths, scores

    x = strengths.to_vector(:scale)
    y = scores.to_vector(:scale)

    Statsample::Bivariate.pearson(x, y)
  end
end