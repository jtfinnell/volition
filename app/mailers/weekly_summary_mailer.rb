class WeeklySummaryMailer < ApplicationMailer
  default from: "summary@usevolition.com"

  def weekly_summary(user)
    mail(to: user.email, subject: "hi")
  end
end
