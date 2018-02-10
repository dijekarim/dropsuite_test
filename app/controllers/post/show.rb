require 'hanami/controller'
require 'base64'
require 'pry'
 
module Post
  class Show
    include Hanami::Action

    def call(params)
      if params[:data] == nil || params[:data] == ""
        dirs = Dir["DropsuiteTest/*"]
      else
        # encode the params to open directories
        dirs = Dir["#{Base64.decode64(params[:data])}/*"]
      end
      
      # generate links for current dir
      links = ""
      dirs.each do |dir|
        links += gen_link(dir)
      end

      # detect the files on current dir
      duplicated_files = detect_duplicated_files(dirs)
      data_file = ""
      if duplicated_files != nil || duplicated_files != {}
        # get max from value
        max_duplicated_files = duplicated_files.max_by{ |k,v| v.length }[0]
        # read the file content
        file = ::File.open(duplicated_files[max_duplicated_files].first, 'r').each { |line| data_file += line }
        # count the length of duplicated file
        count = duplicated_files[max_duplicated_files].length
      else
        data_file = "No files found"
        count = 0
      end

      self.body = LayoutCell.new(nil).(){"#{links}<br>#{data_file} #{count}"}
    end

    private
    def gen_link(dir)
      if ::File.ftype(dir).downcase == 'directory'
        # create directory name to parse as params use base64 encoding
        return "<a href='/data/#{Base64.encode64(dir)}'> #{ dir } </a> <br>" 
      else
        return "#{ dir }<br>"
      end
    end

    def detect_duplicated_files(dirs)
      data_files = {}
      dirs.each do |f|
        next if ::File.directory?(f)
        # detect file with the MD5 digest
        key = ::Digest::MD5.hexdigest(IO.read(f)).to_sym
        if data_files.has_key?(key) then data_files[key].push(f) else data_files[key] = [f] end
      end
      
      return data_files
    end
  end
end