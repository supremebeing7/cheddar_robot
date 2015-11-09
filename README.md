README
==

This app is In Development! It is not currently working, and due to the nature of the approach, once it does start working, it could break at any moment for any of the supported banks if they change their flow.

==

The goal of this app is to allow If This Then That type transactions for bank accounts. 

When a deposit is received from a particular source, for example a paycheck from an employer, triggers should be able to be setup that will initiate some portion of that income to be transferred to another account. 

The primary use case is allow automated savings between different bank accounts.

Because banks generally don't provide a public API, the Cheddar Robot mostly achieves it's purposes through web scraping using the Mechanize and Watir gems.
