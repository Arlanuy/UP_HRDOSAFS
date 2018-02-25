class Contact < MailForm::Base
  attribute :name, :validate => true
  attribute :employee_num, :validate => true
  attribute :contact_num, :validate => true
  attribute :email, :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :subject, :validate => true
  attribute :message, :validate => true
  attribute :nickname, :captcha => true #prevents spambots

  def headers
    {
      :subject => "Contact Form",
      :to => "contact.uphrdosafs@gmail.com",
      :from => %("#{name}" <#{email}>)
    }
  end
end
