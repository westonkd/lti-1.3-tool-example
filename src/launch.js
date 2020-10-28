import React from "react";
import { render } from "react-dom";

import LtiStorageDisplay from "./components/LtiStorageDisplay";

render(
  <LtiStorageDisplay property="high-contrast" />,
  document.getElementById("root")
);
