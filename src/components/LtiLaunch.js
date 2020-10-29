import React from "react";
import LtiStorageDisplay from "../components/LtiStorageDisplay";
import LtiLaunchDisplay from "../components/LtiLaunchDisplay";

const LtiLaunch = () => {
  return (
    <>
      <LtiLaunchDisplay ltiLaunch={window.ENV.lti_launch} />
      <LtiStorageDisplay />
    </>
  );
};

export default LtiLaunch;
