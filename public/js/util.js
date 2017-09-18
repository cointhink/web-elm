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
  s.className = "stripe-button"
  s.setAttribute('src', "https://checkout.stripe.com/checkout.js")
  s.setAttribute('data-key',"pk_test_sp3PVvkNYVuTlsh4cp0EoZrL")
  s.setAttribute('data-amount',"200")
  s.setAttribute('data-name',"CoinThink")
  s.setAttribute('data-description',"Add a new schedule slot")
  s.setAttribute('data-email', email)
  f.appendChild(s)

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