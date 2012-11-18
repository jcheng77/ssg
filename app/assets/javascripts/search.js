$(document).ready(function () {
  $('#search').focus(function () {
    $(this).animate({ width:"360px" }, 500);
  }).blur(function () {
    $(this).animate({ width:"180px" }, 500);
  });
});