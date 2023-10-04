class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :glyph
  belongs_to :parent_comment
end
