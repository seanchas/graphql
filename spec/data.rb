require 'graphql'

module StarWars

  EpisodeEnum = GraphQL::GraphQLEnumType.new do
    name          'Episode'
    description   'One of the films in the Star Wars Trilogy'

    value         'NEWHOPE',  4, description: 'Released in 1977'
    value         'EMPIRE',   5, description: 'Released in 1980'
    value         'JEDI',     6, description: 'Released in 1983'
  end

  CharacterInterface = GraphQL::GraphQLInterfaceType.new do
    name          'Character'
    description   'A character in the Star Wars Trilogy'

    field :id do
      type        !GraphQL::GraphQLString
      description 'The id of the character'
    end

    field :name do
      type        GraphQL::GraphQLString
      description 'The name of the character'
    end

    field :friends do
      type        -> { GraphQL::GraphQLList.new(CharacterInterface) }
      description 'The friends of the character, or an empty list if they have none'
    end

    field :appears_in do
      type        GraphQL::GraphQLList.new(EpisodeEnum)
      description 'Which movies they appear in'
    end

    resolve_type -> (type) { raise "Not implemented. Yet." }
  end

  HumanType = GraphQL::GraphQLObjectType.new do
    name          'Human'
    description   'A humanoid creature in the Star Wars universe'

    field :id, !GraphQL::GraphQLString do
      description 'The id of the human'
    end

    field :name, GraphQL::GraphQLString, description: 'The name of the human'

    field :friends, GraphQL::GraphQLList.new(CharacterInterface) do
      description 'The friends of the human, or an empty list if they have none'
    end

    field :appears_in, GraphQL::GraphQLList.new(EpisodeEnum), description: 'Which movies they appear in'

    field :home_planet, GraphQL::GraphQLString, description: 'The home planet of the human, or null if unknown'

    interface CharacterInterface
  end

  DroidType = GraphQL::GraphQLObjectType.new do
    name          'Droid'
    description   'A mechanical creature in the Star Wars universe'

    field :id, !GraphQL::GraphQLString do
      description 'The id of the droid'
    end

    field :name, GraphQL::GraphQLString, description: 'The name of the droid'

    field :friends, GraphQL::GraphQLList.new(CharacterInterface) do
      description 'The friends of the droid, or an empty list if they have none'
    end

    field :appears_in, GraphQL::GraphQLList.new(EpisodeEnum), description: 'Which movies they appear in'

    field :primary_function, GraphQL::GraphQLString, description: 'The primary function of the droid'

    interface CharacterInterface
  end


  QueryType = GraphQL::GraphQLObjectType.new do
    name 'Query'

    field :hero, CharacterInterface do
      arg :episode, EpisodeEnum do
        description 'If omitted, returns the hero of the whole saga. If provided, returns the hero of that particular episode.'
      end

      resolve lambda { |root, params, *args|
        raise "Not implemented. Yet."
      }
    end

    field :human, HumanType do
      arg :id, !GraphQL::GraphQLString, description: 'Id of the human'

      resolve lambda { |root, params, *args|
        raise "Not implemented. Yet."
      }
    end

    field :driod, DroidType do
      arg :id, !GraphQL::GraphQLString, description: 'Id of the droid'

      resolve lambda { |root, params, *args|
        raise "Not implemented. Yet."
      }
    end
  end

end
