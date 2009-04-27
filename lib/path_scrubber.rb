module PathScrubber
  
  # character groups
  
  # uri - # http://www.ietf.org/rfc/rfc3986.txt
  URI_GEN_DELIMS = [":", "/", "?", "#", "[", "]", "@"] unless defined?(URI_GEN_DELIMS)
  URI_SUB_DELIMS = ["!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="] unless defined?(URI_SUB_DELIMS)
  
  class Scrubber
    def self.set_scrubber_style(name, opts={})
      ::String.set_scrubber_style(name, opts)
      ::Array.set_scrubber_style(name, opts)
      true
    end
  end
  
  module String
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def set_scrubber_style(name, opts={})
        
        uri_reserved_characters = URI_GEN_DELIMS+URI_SUB_DELIMS
        uri_reserved_hash = {}
        uri_reserved_characters.each do |c|
          uri_reserved_hash[c] = ""
        end
        
        @@url_default_scrubber_options = {
          :downcase => true,
          :characters => uri_reserved_hash.merge({
            " " => "-",
            "_" => "-",
            "`" => "",
            "&" => "and"
          })
        }
                
        if opts.empty?
          if name.to_sym == :url
            opts = @@url_default_scrubber_options
          end
        end
        
        eval_ary = []
        
        if opts[:characters] && !opts[:characters].empty?
          eval_ary = eval_ary.concat(opts[:characters].map{|k,v| %{gsub("#{k}", "#{v}")} })
        end
        if opts[:downcase]
          eval_ary << "downcase"
        end
        if opts[:upcase]
          eval_ary << "upcase"
        end
        
        class_eval %{
          def scrub_as_#{name}
            #{eval_ary.join(".")}
          end
        }
        
      end
    end
    
  end # end String module
  
  module Array
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def set_scrubber_style(name, opts={})
        class_eval %{
          def scrub_as_#{name}
            self.map{|e| e.scrub_as_#{name} }
          end
        }
      end
    end
    
  end # end Array module
  
end