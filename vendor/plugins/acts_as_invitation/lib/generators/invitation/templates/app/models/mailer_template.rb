class <%= class_name %>Mailer < ActionMailer::Base

  def <%= file_name %>(email, <%= file_name %>, sent_at = Time.now)
    @subject = '<%= class_name %>Mailer#<%= file_name %>'
    @body[:<%= file_name %>] = <%= file_name %>
    @recipients = email
    @from = 'mailer@mydomain'
    @sent_on = sent_at
  end
end
