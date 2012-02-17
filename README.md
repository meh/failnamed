failnamed - a fail Ruby named implementation.
=============================================

```ruby
listen '0.0.0.0', 53
listen :tcp, '0.0.0.0', 53

forward_to '81.174.67.134', '87.118.111.215'

# records are matched top-down
zones do
  zone 'example.com' do
    # this is a helper method to create A and AAAA records
    ip '127.0.0.1' do
      matches 'what.example.com'
    end

    A '151.68.45.204' do
      matches 'example.com'
      matches '*.example.com'
    end
  end

  zone 'example.it' do
    A 'example.com' do
      matches /(.*\.)?example.it/
    end
  end
end
```
