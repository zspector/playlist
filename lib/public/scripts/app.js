$(document).ready(function() {
  $('#artist, #song_title').change( function() {
    // alert("changing");
    var artist = $('#artist').val();
    artist = artist.replace(/ /, "+");
    var song = $('#song_title').val();
    song = song.replace(/ /g, "+");
    var newurl = "http://www.youtube.com/results?search_query=" + artist + "+" + song;
    $('.youtube-search').attr('href', newurl);
  });
});
