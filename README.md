### Packwerk Test

Showing various privacy settings for constants in packages.
- `building` package does not enfore privacy, every constant defined inside of it is public
- `furniture` package enforces privacy for:
  - `Furniture::Chair` private constant
  - `Furniture::Expensive` private namespace, every constant defined under it will also be private
  - everything else in the package is public implicitly, without there being a `public/` directory

- `vehicle` package enforces privacy for everything
  - only constants defined in the `public/` directory (and its subdirectories) will be public

```
app/packages/
├── building
│   ├── house.rb................................implicitly public constant
│   └── package.yml
├── furniture
│   ├── chair.rb................................private constant
│   ├── expensive...............................private namespace, everything inside it is private
│   │   └── bed.rb..............................private constant
│   ├── package.yml
│   └── table.rb................................implicitly public constant
└── vehicle
    ├── app
    │   └── public..............................explicitly public namespace aka "public API"
    │       ├── car.rb..........................public constant
    │       └── truck.rb........................public constant
    ├── car.rb..................................private constant
    └── package.yml
```

`Building::House` class has the following definition

```ruby
module Building
  class House
    def initialize(size:)
      @size = size
      @vehicle = Vehicle::Car.new
      @truck = Vehicle::Public::Truck.new
      @bed = Furniture::Expensive::Bed.new
      @table = Furniture::Table.new
      @chair = Furniture::Chair.new
    end
  end
end
```

Running `packwerk check` with the following settings will result in the following.

```
app/packages/building/house.rb:5:17
Privacy violation: '::Vehicle::Car' is private to 'app/packages/vehicle' but referenced from 'app/packages/building'.
Is there a public entrypoint in 'app/packages/vehicle/app/public/' that you can use instead?
Inference details: this is a reference to ::Vehicle::Car which seems to be defined in app/packages/vehicle/car.rb.
To receive help interpreting or resolving this error message, see: https://github.com/Shopify/packwerk/blob/main/TROUBLESHOOT.md#Troubleshooting-violations


app/packages/building/house.rb:6:13
Privacy violation: '::Furniture::Expensive::Bed' is private to 'app/packages/furniture' but referenced from 'app/packages/building'.
Is there a public entrypoint in 'app/packages/furniture/app/public/' that you can use instead?
Inference details: this is a reference to ::Furniture::Expensive::Bed which seems to be defined in app/packages/furniture/expensive/bed.rb.
To receive help interpreting or resolving this error message, see: https://github.com/Shopify/packwerk/blob/main/TROUBLESHOOT.md#Troubleshooting-violations


app/packages/building/house.rb:8:15
Privacy violation: '::Furniture::Chair' is private to 'app/packages/furniture' but referenced from 'app/packages/building'.
Is there a public entrypoint in 'app/packages/furniture/app/public/' that you can use instead?
Inference details: this is a reference to ::Furniture::Chair which seems to be defined in app/packages/furniture/chair.rb.
To receive help interpreting or resolving this error message, see: https://github.com/Shopify/packwerk/blob/main/TROUBLESHOOT.md#Troubleshooting-violations


3 offenses detected
```


