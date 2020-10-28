import React, { useState, useCallback, useEffect } from "react";

import {
  ltiStoreStates,
  useLtiStore,
} from "../utils/ltiEvents";

const LtiStorageDisplay = ({ property }) => {
  const { status, data } = useLtiStore();

  if (status === ltiStoreStates.SUCCESS) {
    console.log(data)
  }

  return <h1>hi</h1>
};

export default LtiStorageDisplay;
