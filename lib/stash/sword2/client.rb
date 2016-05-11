module Stash
  module Sword2
    module Client
      Dir.glob(File.expand_path('../client/*.rb', __FILE__)).sort.each(&method(:require))

      attr_reader :username
      attr_reader :password
      attr_reader :on_behalf_of
      attr_reader :helper

      def initialize(username:, password:, on_behalf_of: nil, helper: nil)
        raise 'no username provided' unless username
        raise 'no password provided' unless password
        @username = username
        @password = password
        @on_behalf_of = on_behalf_of || username
        @helper = helper || HTTPHelper.new(username: username, password: password, user_agent: "stash-sword2 #{VERSION}")
      end

      def self.new(*args)
        c = Class.new
        c.send(:include, self)
        c.new(*args)
      end

      def create(collection_uri:, slug:, zipfile:)
        warn "#{zipfile} may not be a zipfile" unless zipfile.downcase.end_with?('.zip')
        uri = Sword2.to_uri(collection_uri).to_s
        md5 = Digest::MD5.file(zipfile).to_s

        File.open(zipfile, 'rb') do |file|
          helper.post(uri: uri, payload: file, headers: {
              'Packaging' => 'http://purl.org/net/sword/package/SimpleZip',
              'On-Behalf-Of' => on_behalf_of,
              'Slug' => slug,
              'Content-MD5' => md5,
              'Content-Disposition' => "attachment; filename=#{File.basename(zipfile)}",
              'Content-Type' => 'application/zip'
          })
        end
      end

      def update(edit_iri:, slug:, zipfile:)
        warn "#{zipfile} may not be a zipfile" unless zipfile.downcase.end_with?('.zip')
        uri = Sword2.to_uri(edit_iri).to_s
        md5 = Digest::MD5.file(zipfile).to_s

        request_headers = {
            'Content-Type' => 'multipart/related',
            'On-Behalf-Of' => on_behalf_of
        }

        mime_headers = {
            'Packaging' => 'http://purl.org/net/sword/package/SimpleZip',
            'Content-Disposition' => 'attachment; name="payload"; filename="example.zip"',
            'Content-Type' => 'application/zip',
            'Content-MD5' => md5
        }

        File.open(zipfile, 'rb') do |file|
          helper.put(uri: uri, headers: request_headers, payload: {
              metadata: mime_headers,
              file: file
          })
        end

      end

    end
  end
end
