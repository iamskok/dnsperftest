# DNS Performance Test (Pi-Hole Edition)

Fork of [dnsperftest](https://github.com/cleanbrowsing/dnsperftest) script.
The script was updated to run inside of Pi-Hole to determine the most
performant DNS resolvers. Includes 1.000.000 most popular domains.
Doesn't include DNS resolves, because there are meant to be configured in
Pi-Hole admin dashboard.

# Required 

You need to install `bc` and `dig`. For Ubuntu:

```
sudo apt-get install -y bc dnsutils
```

# Utilization

``` 
git clone https://github.com/iamskok/dnsperftest.git
cd dnsperftest
bash ./dnstest.sh
```
