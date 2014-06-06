class ShareLinkMailer < ActionMailer::Base
  default from: "share@cubbyhole.com"

  def link_email(sender, share_link, email)
    @sender = sender
    @share_link = share_link
    mail(to: email, subject: "#{sender.username} shared a link with you!")
  end
end
