$(document).on("turbolinks:load", function () {
  $("#b-drop").click(function () {
    $("#drop").fadeToggle();
    $("#drop-in").fadeOut();
  });
  $("#b-drop-in").click(function () {
    $("#drop-in").fadeToggle();
    $("#drop").fadeOut();
  });
  $("#b-notice").click(function () {
    $("#notice").fadeOut();
  });
  $("#b-alert").click(function () {
    $("#alert").fadeOut();
  });
});
