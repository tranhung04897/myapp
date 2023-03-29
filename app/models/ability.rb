# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
    user ||= User.new
    case true
    when user.is_admin?
      can :manage, :all
    when user.is_manager?
      can [:manage], OsiCa
      cannot [:new, :create], OsiCa
      can [:manage], OsiBooker
      cannot [:new, :create], OsiBooker
      can [:read, :edit, :update], User, { id: user.id }
      can [:read, :edit, :update], User, { role_id: 3 }
      cannot [:create], User
      can [:manage, :download, :download_data, :export, :ajax_download_data, :delete_order,
           :update_order, :import], OrderInfomation
    else
      cannot [:manage], User
      can [:read], OsiCa
      can [:read], OsiBooker
      can [:manage, :download, :download_data, :export, :ajax_download_data, :delete_order,
           :update_order, :import], OrderInfomation
    end
  end
end
