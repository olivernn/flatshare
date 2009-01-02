module Slantwise  #:nodoc:
  module Acts  #:nodoc:
    module Invitation  #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_invitation(options = {})
          attr_reader :failed_addresses
          attr_reader :recipient_list
          name = options[:name] ? options[:name] : "Invitation"
          write_inheritable_attribute(:class_name, name) 
          
          class_inheritable_reader :class_name

          before_create :send_emails
          validate_on_create :check_recipients
          
          include InstanceMethods
        end
      end
      
      module InstanceMethods
        def check_recipients
          return unless recipients.nil? or recipients.empty?  
          if @failed_addresses.empty?
            errors.add(:recipient_list, "can't be blank") 
          else
            errors.add(:recipient_list, "does not include any valid addresses")
          end
        end

        def recipient_list=(r)
          @recipient_list = r
          @addresses = []
          @failed_addresses = []
          r.gsub(",", " ").split(" ").each do |a|
            a.strip!
            if a =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
              @addresses << a
            else
              @failed_addresses << a
            end
          end
          self.recipients = @addresses.join(", ") 
        end

        def send_emails
          @addresses.each {|a| "#{class_name}Mailer".constantize.send("deliver_#{class_name.camelize.downcase}".to_sym, a, self) }
        end
      end
    end
  end
end