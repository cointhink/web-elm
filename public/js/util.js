function ws_setup() {
    let ws_proto = 'https:' == document.location.protocol ? 'wss:' : 'ws:'
    let ws_host = window.location.host.split(':')[0]
    let ws_port = ws_host == "localhost" ? ':8085' : ''
    let ws_url = ws_proto + '//' + ws_host + ws_port + '/ws'
    let url_token = getParameterByName('token', document.location)
    if (url_token) {  localStorage.setItem('token', url_token) }
    return ws_url
}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function stripePay(email) {
  var myNode = document.getElementById("card-container")
  myNode.style.display = "block"

/*
  var stripe = Stripe('pk_test_sp3PVvkNYVuTlsh4cp0EoZrL');
  var elements = stripe.elements();
  var card = elements.create('card')
  card.mount('#card-element')
*/

  var f = document.createElement("form")
  f.setAttribute('method',"post")
  f.setAttribute('action',"/stripe")

  var s = document.createElement("script")
  s.setAttribute('src', "https://js.stripe.com/v3/")
  f.appendChild(s)

  var s = document.createElement("script")
  s.className = "stripe-button"
  s.setAttribute('src', "https://checkout.stripe.com/checkout.js")
  s.setAttribute('data-key',"pk_test_sp3PVvkNYVuTlsh4cp0EoZrL")
  s.setAttribute('data-amount',"200")
  s.setAttribute('data-name',"CoinThink")
  s.setAttribute('data-description',"Buy 1 schedule credit.")
  s.setAttribute('data-email', email)
  f.appendChild(s)

  var ifield = document.createElement("input")
  ifield.setAttribute('type', 'hidden')
  ifield.setAttribute('name', 'cointhink-token')
  ifield.setAttribute('value', localStorage.getItem('token'))
  f.appendChild(ifield)

  document.getElementById('card-element').appendChild(f);

/*
<form action="/your-server-side-code" method="POST">
  <script
    src="https://checkout.stripe.com/checkout.js" class="stripe-button"
    data-key="pk_test_sp3PVvkNYVuTlsh4cp0EoZrL"
    data-amount="999"
    data-name="CoinThink"
    data-description="Widget"
    data-image="https://stripe.com/img/documentation/checkout/marketplace.png"
    data-locale="auto"
    data-zip-code="true">
  </script>
</form>
*/
}