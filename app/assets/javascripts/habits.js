$(document).on('turbolinks:load', function() {
  $(document).on('click', '.js--showHabitForm', function() {
    $(this).addClass('hidden')
    $(this).prev('.habitForm').removeClass('hidden')
  })
})
