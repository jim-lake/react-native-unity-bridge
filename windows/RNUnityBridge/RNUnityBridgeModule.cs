using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Unity.Bridge.RNUnityBridge
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNUnityBridgeModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNUnityBridgeModule"/>.
        /// </summary>
        internal RNUnityBridgeModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNUnityBridge";
            }
        }
    }
}
