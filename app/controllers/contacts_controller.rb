class ContactsController < ApplicationController
    def new
      @contact = Contact.new
    end

    def create
      @error = 0
      @message = ""
      @contact = Contact.new(params[:contact])
      @contact.request = request
      if @contact.deliver
        #flash.now[:message] = nil
        @error = 0
        @message = "<div class='ui icon message success'>
              <div class='content'>
                <div class='header'>Message successfully sent!</div>
                <p>We will be in touch with you soon</p></div></div>"
        render :new

      else
        #flash.now[:message] = 'Cannot send message.'
        @error = 1
        @message = "<div class='ui icon message error'>
              <div class='content'>
                <div class='header'>Could not send your message! Please resend your e-mail.</div>
                <p>Contact HRDO if the problem still persists.</p></div></div>"
        render :new
      end
    end
end
