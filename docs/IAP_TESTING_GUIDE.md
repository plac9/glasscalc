# PrismCalc - In-App Purchase Testing Guide

## StoreKit Configuration File Testing (Simulator)

PrismCalc uses **StoreKit Configuration File** for local testing without needing App Store Connect setup.

### ✅ Current Status

- **StoreKit Config**: `App/Configuration.storekit` ✅
- **Product ID**: `com.laclairtech.prismcalc.pro` ✅
- **Price**: $2.99 ✅
- **Type**: Non-Consumable ✅

---

## Testing IAP in Simulator

### 1. **Launch App** (Already Running)
The app is currently running in the iPhone 17 Pro Max simulator.

### 2. **Test Free Tier Features**

#### Free Access (Should Work):
- ✅ Basic Calculator
- ✅ History (last 10 items only)
- ✅ Aurora theme
- ✅ Settings

#### Gated Features (Should Show Paywall):
- ❌ Tip Calculator → Tap to see paywall
- ❌ Discount Calculator → Tap to see paywall
- ❌ Split Bill → Tap to see paywall
- ❌ Unit Converter → Tap to see paywall
- ❌ Premium Themes → Locked in Settings

### 3. **Test Purchase Flow**

#### Step-by-Step Purchase Test:
1. **Trigger Paywall**
   - Tap the "Tip" tab
   - You should see the paywall with "Upgrade for $2.99"

2. **Initiate Purchase**
   - Tap "Upgrade for $2.99" button
   - StoreKit sandbox will show purchase dialog

3. **Confirm Purchase**
   - Tap "Subscribe" or "Buy" in the dialog
   - **No actual payment** - this is sandbox testing

4. **Verify Pro Access**
   - Paywall should dismiss
   - Tip Calculator should now be accessible
   - Go to Settings → All themes should be unlocked
   - History should show "Unlimited" instead of limit banner

5. **Verify Persistence**
   - Close and relaunch the app
   - Pro features should remain unlocked
   - No need to purchase again

### 4. **Test Restore Purchases**

#### Reset Purchase (to test restore):
1. **Clear Simulator Purchase State**
   ```bash
   xcrun simctl uninstall booted com.laclairtech.prismcalc
   xcrun simctl install booted /path/to/PrismCalc.app
   xcrun simctl launch booted com.laclairtech.prismcalc
   ```

2. **Test Restore**
   - Trigger any paywall
   - Tap "Restore Purchases" button
   - Should restore Pro access without repurchasing

### 5. **Test Error Handling**

#### Enable StoreKit Errors:
1. Open `App/Configuration.storekit` in Xcode
2. Go to "Editor" menu → "Enable StoreKit Testing"
3. Test scenarios:
   - **Purchase Failed**: Enable "Purchase" error
   - **Verification Failed**: Enable "Verification" error
   - **Network Error**: Enable "Load Products" error

---

## Expected Behavior

### ✅ Free Tier
| Feature | Status |
|---------|--------|
| Calculator | Full access |
| History | Last 10 items + upgrade banner |
| Themes | Aurora only (others locked) |
| Pro Tools | Paywalled |

### ✅ Pro Tier (After Purchase)
| Feature | Status |
|---------|--------|
| Calculator | Full access |
| History | Unlimited |
| Themes | All 6 unlocked |
| Tip Calculator | Full access |
| Discount Calculator | Full access |
| Split Bill | Full access |
| Unit Converter | Full access |

---

## Troubleshooting

### Purchase Not Working
1. **Check StoreKit Configuration**
   - Xcode → Product → Scheme → Edit Scheme
   - Run → Options → StoreKit Configuration
   - Ensure `Configuration.storekit` is selected

2. **Clear Simulator**
   ```bash
   xcrun simctl erase all
   ```

3. **Check Console Logs**
   ```bash
   xcrun simctl spawn booted log stream --predicate 'subsystem == "com.laclairtech.prismcalc"'
   ```

### Pro Features Not Unlocking
1. Check `StoreKitManager.shared.isPro` in debugger
2. Verify transaction was verified successfully
3. Check `purchasedProductIDs` contains product ID

### Restore Not Working
1. Ensure you've made at least one purchase
2. Check App Store sync is enabled in StoreKit config
3. Try `await AppStore.sync()` manually

---

## Testing Checklist

- [ ] Free tier shows only free features
- [ ] Paywalls appear for Pro features
- [ ] Purchase button shows correct price ($2.99)
- [ ] Purchase completes successfully
- [ ] Pro features unlock after purchase
- [ ] Purchase persists after app restart
- [ ] Restore purchases works
- [ ] Loading states show during purchase
- [ ] Error messages display properly
- [ ] History upgrade banner appears (free tier)
- [ ] Theme locks work correctly

---

## Next: Sandbox Testing with TestFlight

Once App Store Connect is set up, test with real sandbox accounts:

1. Create sandbox tester in App Store Connect
2. Sign out of App Store on device
3. Install via TestFlight
4. Purchase with sandbox account
5. Verify across devices (family sharing)

---

## StoreKit Configuration vs Sandbox

| Feature | StoreKit Config | Sandbox Account |
|---------|----------------|-----------------|
| Location | Local simulator | Real device/TestFlight |
| Setup | No setup needed | Requires App Store Connect |
| Payment | Simulated | Simulated (no charge) |
| Best For | Development | Pre-release testing |

---

## Current Test Status

🟢 **Ready to Test**
- StoreKit configuration loaded
- App running in simulator
- Product ID configured correctly

**Next Step**: Follow testing steps above in the simulator!
