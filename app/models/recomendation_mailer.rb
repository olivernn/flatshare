class RecomendationMailer < ActionMailer::Base

  def recomendation(email, recomendation, sent_at = Time.now)
    @subject = 'RecomendationMailer#recomendation'
    @body[:recomendation] = recomendation
    @recipients = email
    @from = 'mailer@mydomain'
    @sent_on = sent_at
  end
end
