class HistoricAppointmentsIndexPresenter
  def initialize(historic_appointments_index)
    @historic_appointments_index = historic_appointments_index
  end

  def featured_profile_groups
    if @historic_appointments_index.selection_of_profiles
      { selection_of_profiles: @historic_appointments_index.selection_of_profiles }
    else
      {}
    end
  end

  def other_profile_groups
    @historic_appointments_index.centuries_data
  end
end
