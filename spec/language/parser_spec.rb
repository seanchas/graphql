require 'awesome_print'
require 'graphql'

RSpec.describe GraphQL::Language do

  def q01
    %Q(
      {
        me(at: { a: $value, b: 2, c: 3 }, for: [1, 2, $value])
      }
    )
  end

  def q02
    %Q(
      {
        user(id: 4) {
          id name
          smallPic: profilePic(width: 100, height: 50)
        }
      }
    )
  end

  def q03
    %Q(
      {
        zuck: user(id: 4) {
          id name
        }
      }
    )
  end

  def q04
    %Q(
      query withFragments($id: [Int!]! = 1) {
        zuck: user(id: 4) @include (if: true) {
          friends(first: 10) {
            ... friendFields
          }
          mutualFriends(first: "10") {
            ... friendFields @skip(if: $variable)
          }
          ... on User @include(if: $should) {
            occupation
          }
        }
      }

      {
        me
      }

      fragment friendFields on User @include(if: false) {
        id
        name @skip
        profilePic(size: 50) @include
      }
    )
  end

  def q05

  end



  it "Should parse query" do
    begin
      puts GraphQL::Language.parse(q01).inspect
    rescue Parslet::ParseFailed => failure
      puts failure.cause.ascii_tree
    end
  end

end
