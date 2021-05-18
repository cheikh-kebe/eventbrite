class AttendanceMailer < ApplicationMailer

  default from: 'bousquet.valentin@gmail.com'
 
  def new_guest_email(attendance)
    #on récupère l'instance user pour ensuite pouvoir la passer à la view en @user
    @attendance = attendance

    #on définit une variable @url qu'on utilisera dans la view d’e-mail
    @url  = 'http://monsite.fr/login' 

    # c'est cet appel à mail() qui permet d'envoyer l’e-mail en définissant destinataire et sujet.
    mail(to: @attendance.event.admin.email, subject: 'Nouvel invité dans ton évènement!') 
  end

end