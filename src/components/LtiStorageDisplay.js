import React, { useEffect } from "react";
import { Row, Col, Input, PageHeader, Button } from "antd";

import "antd/dist/antd.css";

import {
  ltiStoreStates,
  useLtiStore,
  storeNewData
} from "../utils/ltiEvents";

const LtiStorageDisplay = ({ property }) => {
  const { status, data } = useLtiStore();

  return (
    <>
      <PageHeader
        className="site-page-header"
        title="LTI Storage Service Demo"
        subTitle={`Status: ${status}`}
        extra={[
          <Button key="1" onClick={storeNewData}>
            Store New Data
              </Button>
        ]}
      />
      <Input.TextArea
        rows={10}
        value={JSON.stringify(data, null, 2)}
        style={{ fontFamily: '"Courier New", Courier, monospace' }}
      />
    </>
  );
};

export default LtiStorageDisplay;
