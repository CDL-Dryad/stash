require_dependency 'stash_datacite/application_controller'

module StashDatacite
  # this is a class for composite (AJAX/UJS?) views starting at the resource or resources
  class ResourcesController < ApplicationController
    before_action :ajax_require_current_user, only: [:user_in_progress]
    before_action :set_page_info
    # get resources and composite information for in-progress table view
    def user_in_progress
      respond_to do |format|
        format.js do
          #paging first and using separate object for pager (resources) from display (@in_progress_lines) means
          #only a page of objects needs calculations for display rather than all objects in list.  However if we need
          #to sort on calculated fields for display we'll need to calculate all values, sort and use the array pager
          #form of kaminari instead (which will likely be slower).
          @resources = StashDatacite.resource_class.where(user_id: session[:user_id]).in_progress.
              page(@page).per(@page_size)
          @in_progress_lines = @resources.map { |resource| DatasetPresenter.new(resource) }
        end
      end
    end

    def user_submitted
      respond_to do |format|
        format.js do
          #@resources = StashDatacite.resource_class.where(user_id: session[:user_id]).submitted.
          @resources = current_user.latest_completed_resource_per_identifier.
              page(@page).per(@page_size)
          @submitted_lines = @resources.map { |resource| DatasetPresenter.new(resource) }
        end
      end
    end

    def show
      respond_to do |format|
        format.js do
          @resource = StashDatacite.resource_class.find(params[:id])
          @data = check_required_fields(@resource)
          @review = Resource::Review.new(@resource)
        end
      end
    end

    # Review responds as a get request to review the resource before saving
    def review
      respond_to do |format|
        format.js do
          @resource = StashDatacite.resource_class.find(params[:id])
          check_required_fields(@resource)
          @review = Resource::Review.new(@resource)
        end
      end
    end

    def submission
      resource = StashDatacite.resource_class.find(params[:resource_id])
      file_generation(resource)
      create_resource_state(resource)
      redirect_to stash_url_helpers.dashboard_path, notice: "#{resource.titles.first.title} submitted
        with DOI #{resource.identifier.identifier}.
        There may be a delay for processing before the item is available."
    end

    private

    def check_required_fields(resource)
      @completions = Resource::Completions.new(resource)
      # required fields are Title, Institution, Data type, Data Creator(s), Abstract
      unless @completions.required_completed == @completions.required_total
        @data = []
        @data << 'Title' unless @completions.title
        @data << 'Resource Type' unless @completions.data_type
        @data << 'Abstract' unless @completions.abstract
        @data << 'Author(s)' unless @completions.creator_name
        @data << 'Author Affiliation' unless @completions.creator_affliation
        return @data.join(', ').split(/\W+/)
      end
    end

    def file_generation(resource)
      @resource_file_generation = Resource::ResourceFileGeneration.new(resource, current_tenant)
      identifier = @resource_file_generation.generate_identifier
      target_url = current_tenant.landing_url(stash_url_helpers.show_path(identifier))
      @resource_file_generation.generate_merritt_zip(target_url, identifier)
      zipfile = "#{Rails.root}/uploads/#{resource.id}_archive.zip"
      title = main_title(resource)
      resource.submission_to_repository(current_tenant, zipfile, title, identifier)
    end

    def create_resource_state(resource)
      data = check_required_fields(resource)
      if data.nil?
        unless resource.current_resource_state == 'submitted'
          StashEngine::ResourceState.create!(resource_id: resource.id, resource_state: 'submitted',
                                             user_id: current_user.id)
        end
      end
      send_user_mail(resource)
    end

    # TODO: remove this once mail is sent from stash_engine/delayed jobs
    def send_user_mail(resource)
      title = main_title(resource)
      UserMailer.notification(
        resource.user.email,
        "Dataset submitted: #{title.try(:title)}",
        'submission',
        { user: resource.user, resource: resource, title: title.try(:title),
          identifier: resource.identifier, path: stash_url_helpers.dashboard_path }).deliver
    end

    def main_title(resource)
      resource.titles.where(title_type: :main).first
    end
  end
end
