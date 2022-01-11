# apolloApp
# A Swift 5 IOS App for reading data from a BLE oximeter ring communicating heart rate, SPO2, blood pressure, and other statistics
#C code for ring can be found here: https://github.com/rebondy/Apollo-Ring


https://user-images.githubusercontent.com/86892271/149026005-9d24595a-92bf-472c-af85-85c616755872.mov



# Hardware
The intended ring will use a [Maxim 32664](https://datasheets.maximintegrated.com/en/ds/MAX32664.pdf) oximeter with an algorithm chip to compute blood pressure, heart rate, and SPO2 based on red absorption and infared absorption. Raw data from the oximeter is also planned to be used within our own calculations, for heart rate variability, and cardiac output. The bluetooth chip is a Nordic NRF 52382, and runs on the bluefruit API.
# SwiftUI
All the graphics within app are generated with Swiftuis easy declarative syntax. No packages are used for any main UI graphic.
# CoreData
CoreData is used to load the large sets of timestamped data for the statistics are loaded into a quick access container, making load times non existant, even with a years worth of data.
# CoreBluetooth
CoreBluetooth is used to scan for peripherals and find our device based upon a unique device identifier. Upon conneection being established the initialized manager object will add the recieved value to the coredata object representing the statistic
