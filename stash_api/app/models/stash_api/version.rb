module StashApi
  class Version

    attr_reader :resource
    def initialize(resource_id:)
      @resource = StashEngine::Resource.find(resource_id)
    end

    def metadata
      m = Metadata.new(resource: @resource)
      m.value
    end
  end
end
