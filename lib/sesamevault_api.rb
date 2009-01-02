#  SesameVault Ruby API Library
#
#  last updated on 05/13/08 (MM/DD/YY)
#  http://www.sesamevault.com/developer

require 'net/http'
require 'digest/md5'
require 'yaml'
require 'cgi'

module SesameVault
  class SesameError < RuntimeError
    attr :code
    attr :message
    attr :sig

    def initialize(code = nil, message = nil, sig = nil)
      @code     = code
      @message  = message
      @sig      = sig
    end
  end

  class Session
    include YAML
    include Digest
    include Net

    @@sesame_host       = 'www.sesamevault.com'
    @@sesame_port       = '80'
    @@sesame_version    = '1.0'
    @@sesame_user_agent = 'SesameVaultAPI_Ruby(1.0)'

    attr_accessor   :user
    attr_accessor   :pass
    attr_accessor   :version


    def initialize(user = nil, pass = nil, version = nil)
      self.user     = user
      self.pass     = pass
      self.version  = version || @@sesame_version
    end


    def create_signature(path = '', data = '', persistent = false)
      time = persistent ? '' : Time.now.to_f.to_s
      cypher = MD5.hexdigest(self.pass)
      version = self.version || @@sesame_version
      sig =  version + ':' + self.user + ':' + MD5.hexdigest(cypher + MD5.hexdigest(time + self.user + cypher + path + data))
      return {:sig => sig, :time => time}
    end


    def get(path = nil, data = {}, query_params = {})
      return {} unless path.class == String

      path_reg = path.match(/(.*?)\.(\w*?)$/)
      path = path_reg[1] if path_reg
      path = '/' + path unless path[0] == 47
      path += '.yaml'

      data = {} unless data.class == Hash
      if not data.empty?
        begin
          data = data.to_yaml
        rescue RuntimeError => err
          data = ''
        end
      end
      data = '' unless data.class == String

      version = self.version || @@sesame_version

      sig_hash  = create_signature(path, data)
      sig       = sig_hash[:sig];
      time      = sig_hash[:time];

      if not query_params.empty?
        query_params = query_params.map{|key, value| "#{CGI.escape(key)}=#{CGI.escape(value)}"}.join('&')
        path += '?' + query_params
      end

      head = {
        'Authorization'   => sig,
        'x-sesame-date'   => time,
        'Date'            => time,
        'User-Agent'      => @@sesame_user_agent,
        'Content-Type'    => 'application/yaml'
      }

      results = {}
      HTTP.new(@@sesame_host, @@sesame_port).start do |http|
        response = http.post(path, data, head)

        results_str = response.body

        begin
          results_yaml = YAML.parse results_str
        rescue
          results_yaml = YAML.parse "{}"
        end

        results = results_yaml.transform
      end

      if results.class == Hash and results['error']
        raise SesameError.new(results['error']['code'], results['error']['message'], results['error']['sig']), results['error']['message']
      end

      yield results if block_given?
      results
    end


    def new_upload_key
      self.get('/upload/new_upload_key') {|r| return r['upload_key']}
    end


    def upload_progress(upload_key)
      self.get('/upload/progress', nil, {'upload_key' => upload_key}) {|r| yield(r)}
    end


    def add_sig_to_url(url, data = '', persistent = false)
      url_rel = url.gsub('//', '')
      url_rel = (url_rel+'?').match(/\/(.*?)\?/)[1]
      url_rel = '/' + url_rel unless url_rel[0].chr == '/'

      auth = self.create_signature(url_rel, data, persistent)

      params = '_sig=' + CGI.escape(auth[:sig]) + '&_date=' + CGI.escape(auth[:time])
      if url.match(/\?/)
        url += '&' + params
      else
        url += '?' + params
      end

      url
    end


    def videos(params = {})
      data = {}

      # add saved filter stack to query
      if params[:filter_id]
        data[:filter_stack] = {}
        data[:filter_stack][:info] = {:stackid => params[:filter_id]}
      end

      # add profiles to query
      profiles = params[:include_profiles] || []
      profiles << params[:include_profile] if params[:include_profile]

      if not profiles.empty?
        data[:profiles] = []
        profiles.each {|p| data[:profiles] << p}
      end

      # add filters to query
      filters = params[:filters] || []
      filters << params[:filter] if params[:filter]
      if not filters.empty?
        data[:filter_stack] ||= {}
        data[:filter_stack][:filters] = filters
      end

      # get videos from SesameVault
      videos = self.get('vault/videos', data)

      # public / private check
      if params[:public]
        tmp_videos = []
        videos = videos.each {|v| tmp_videos << v if v[:public]}
        videos = tmp_videos
      end

      videos
    end

  end
end


class Hash
  def send_to_sesame(connection, path = nil, query_params = {})
    connection.get(path, self, query_params) {|r| yield(r) if block_given?}
  end
end
