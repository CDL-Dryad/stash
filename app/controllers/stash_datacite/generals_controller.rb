require_dependency "stash_datacite/application_controller"

module StashDatacite
  class GeneralsController < ApplicationController

    # GET /generals
    def index
      set_resources
    end

    def new
      set_resources
      @relation_types = RelationType.all
      @related_identifier_types = RelatedIdentifierType.all
      @creator = Creator.new
      @title = Title.new
      @description = Description.new
      @contributor = Contributor.new
      @subject = Subject.new
      @resource_type = ResourceType.new
      @related_identifier = RelatedIdentifier.new
      @geolocation_point = GeolocationPoint.new
      @geolocation_box = GeolocationBox.new
    end

    # GET /generals/id/edit
    # def edit
    #   set_resources
    #   #@creator = Creator.where(resource_id: @resource.id).first_or_initialize
    # end

    # POST /generals/create
    def create
      @resource = StashDatacite.resource_class.constantize.find(generals_params[:resource_id].to_i)
      @creator = Creator.new(creator_params)
      @title = Title.new(title_params)
      @description = Description.new(description_params)
      @contributor = Contributor.new(contributor_params)
      @subject = Subject.new(subject_params)
      @resource_type = ResourceType.new(resource_type_params)
      @related_identifier = RelatedIdentifier.new(related_identifier_params)
      @geolocation_point = GeolocationPoint.new(geolocation_point_params)
      @geolocation_box = GeolocationBox.new(geolocation_box_params)
    end

    def destroy
    end

    def upload
    end

    def summary
    end

    private

      def generals_params
        params.require(:general).permit(:resource_id)
      end

      def set_resources
        @resources = StashDatacite.resource_class.constantize.all
      end

      def creator_params
        params.require(:creator).permit(:creator_first_name, :creator_middle_name, :creator_last_name, :name_identifier_id, :affliation_id, :resource_id)
      end

      def title_params
        params.require(:title).permit(:title, :titleType, :resource_id)
      end

      def description_params
        params.require(:description).permit(:description, :descriptionType, :resource_id)
      end

      def contributor_params
        params.require(:contributor).permit(:contributor_name, :contributor_type, :name_identifier_id, :affliation_id, :resource_id )
      end

      def subject_params
        params.require(:subject).permit(:subject, :subject_scheme, :scheme_URI, :resource_id)
      end

      def resource_type_params
        params.require(:resource_type).permit(:resource_type, :resource_type_general, :resource_id)
      end

      def related_identifier_params
        params.require(:related_identifier).permit(:related_identifier, :related_identifier_type_id, :relation_type_id, :resource_id)
      end

      def geolocation_point_params
        params.require(:geolocation_point).permit(:latitude, :longitude, :geo_location_place, :resource_id)
      end

      def geolocation_box_params
        params.require(:geolocation_point).permit(:sw_latitude, :ne_latitude, :sw_longitude, :ne_longitude, :resource_id)
      end
  end
end
