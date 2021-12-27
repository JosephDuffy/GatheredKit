# GatheredKitMotion

The GatheredKitMotion package wraps the [Core Motion framework](https://developer.apple.com/documentation/coremotion). Note that there are some restrictions in place when using this package.

## Restrictions

Only a single instance of `CMMotionManager` can be created. GatheredKitMotion automatically creates a [shared instance](CMMotionManager.gatheredKitShared), which you can also set to your own value if required. Note that this can't be set after creating any of the following ``Source``s using the shared instance:


- ``Accelerometer``
- ``DeviceMotion``
- ``Gyroscope``
- ``Magnetometer``

Due to these restriction **all instance of the same source will share the same update interval**; it is recommended only a single instance of each source is created.

## Sources

This package provides:

- [x] ``Accelerometer``
- [ ] Activity
- [x] ``Altimeter``
- [x] ``DeviceMotion``
- [x] ``Gyroscope``
- [ ] HeadphoneMotion
- [x] ``Magnetometer``
- [ ] Pedometer
