<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>GPX track</title>
    <script src="//polyfill.io/v3/polyfill.min.js?features=document.querySelector%2CArray.prototype.at"></script>
    <script src="//cdn.jsdelivr.net/gh/Luuka/GPXParser.js/dist/GPXParser.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.0/leaflet.min.js"></script>
    <script src="//cdn.jsdelivr.net/gh/iosphere/Leaflet.hotline/dist/leaflet.hotline.min.js"></script>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.0/leaflet.css" />

    <style>
      h2 {
        font-family: sans-serif;
      }

      #map {
        height: 85vh;
        width: 99vw;
      }
    </style>
  </head>
  <body>
    <h2 id="lastUpdate"></h2>
    <div id="map"></div>

    <script>
      let tagmap = L.map("map");

      L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        maxZoom: 19,
      }).addTo(tagmap);

      function drawTrack(track) {
        let z = 0;
        let coordinates = track.points.map((p) => [p.lat.toFixed(5), p.lon.toFixed(5), z++]);

        let polyline = L.hotline(coordinates, {
          min: 0,
          max: z,
          weight: 5,
          palette: {
            0.0: "#008800",
            0.5: "#ffff00",
            1.0: "#ff0000",
          },
          outlineColor: "#000000",
          outlineWidth: 1,
        }).addTo(tagmap);
        L.circle(coordinates.at(-1), { radius: 5 }).addTo(tagmap);

        // zoom the map to the polyline
        tagmap.fitBounds(polyline.getBounds());
      }

      let url_string = window.location.href;
      let url = new URL(url_string);
      let trackPath = url.searchParams.get("track");
      if (!trackPath) {
        trackPath = "data/data.gpx";
      }

      fetch(trackPath)
        .then(function (response) {
          return response.text();
        })
        .then(function (gpxData) {
          let gpx = new gpxParser();
          gpx.parse(gpxData);
          drawTrack(gpx.tracks[0]);
          document.getElementById("lastUpdate").innerText = gpx.tracks[0].points.at(-1).time.toLocaleString();
        });
    </script>
  </body>
</html>
