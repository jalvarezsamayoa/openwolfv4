class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= Usuario.new # guest user (not logged in)


    if user.has_role?(:superadmin)
      can :manage, :all

      cannot :ver_menu_laip, Usuario
      can :ver_menu_admin, Usuario
      can :ver_menu_admin_catalogos, Usuario
      can :ver_menu_herramientas, Usuario

      can :asignar_institucion, Usuario
      can :asignar_all_institucion, Usuario

      can :asignar_roles, Usuario
      can :asignar_all_roles, Usuario

    elsif user.has_role?(:localadmin)
      can :manage, Usuario

      can :ver_menu_admin, Usuario
      cannot :ver_menu_admin_catalogos, Usuario
      cannot :ver_menu_herramientas, Usuario
      cannot :ver_menu_laip, Usuario

      can :asignar_institucion, Usuario
      can :asignar_roles, Usuario

      cannot :asignar_all_institucion, Usuario
      cannot :asignar_all_roles, Usuario

    elsif user.has_role?(:superudip)
      can :manage, Solicitud
      can :manage, Actividad
      can :manage, Seguimiento
      can :manage, Adjunto

      can :ver_menu_laip, Usuario
      cannot :ver_menu_admin, Usuario
      cannot :ver_menu_herramientas, Usuario

    elsif user.has_role?(:userudip)
      can :manage, Solicitud
    else
      can :read, Solicitud
    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
