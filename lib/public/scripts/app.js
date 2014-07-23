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

$(document).ready(function() {
  $(".get-videos").on('click', function () {
    var artist = $('#artist').val();
    artist = artist.replace(/ /, "+");
    var song = $('#song_title').val();
    song = song.replace(/ /g, "+");
    var limit = 10;
    // var JSONurl = "http://gdata.youtube.com/feeds/api/videos?q=" + artist + "+" + song + "&alt=json" + "&max-results=" + limit;
    var JSONurl = "http://gdata.youtube.com/feeds/api/videos?q=" + artist + "+" + song + "v=2&&alt=json&prettyprint=true&max-results=" + limit;
    console.log(JSONurl);
    // $('.youtube-search').attr('href', newurl);
    // var result;
    var a = $.getJSON(JSONurl, function(data) {
      console.log(data);
      // var entries = data.feed.entry;
      window.entries = data.feed.entry;
      console.log(entries);
      for (var i in entries) {
        var title = entries[i].title.$t;
        var views = entries[i].yt$statistics.viewCount;
        var thumbnail = entries[i].media$group.media$thumbnail[1].url;
        var duration = parseInt(entries[i].media$group.yt$duration.seconds);
        var minutes = Math.floor(duration/60);
        var seconds = duration % 60;
        // console.log(entries[i].title.$t);
        console.log(title, views, thumbnail, duration, minutes +":" + seconds);
        // $("#song-form").after(
        $(".song-fetch-list").append(
          '<div class="small-12 large-12 columns item-hover pointer video-preview" data-id='+ i + '> \
            <div class="columns small-4 large-4"> \
             <div><img src="' + thumbnail +'"></div> \
            </div> \
            <div class="columns small-8 large-8"> \
              <div class="video-title">' + title +'</div> \
              <div class="video-duration">' + minutes + ':' + seconds +' | \
              ' + views +' views</div> \
            </div> \
          </div> \
          '
          );
      }

$(".video-preview").on('click', function () {
    console.log("test");
    var i = $(this).data("id");
    var newurl = window.entries[i].media$group.media$player[0].url;
    console.log(newurl);
    var ampIndex = newurl.indexOf('&');
    newurl = newurl.substring(0, ampIndex != -1 ? ampIndex : s.length);
    $("#url").val(newurl);
    // $(window).scrollTop(0);
    $(document).scrollTop(0);
});

    });

  });

});
