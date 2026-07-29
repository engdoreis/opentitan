# Registers

<!-- BEGIN CMDGEN util/regtool.py -d ./hw/top_peppermint/ip_autogen/clkmgr/data/clkmgr.hjson -->
## Summary

| Name                                                         | Offset   |   Length | Description                                  |
|:-------------------------------------------------------------|:---------|---------:|:---------------------------------------------|
| clkmgr.[`ALERT_TEST`](#alert_test)                           | 0x0      |        4 | Alert Test Register                          |
| clkmgr.[`JITTER_REGWEN`](#jitter_regwen)                     | 0x10     |        4 | Jitter write enable                          |
| clkmgr.[`JITTER_ENABLE`](#jitter_enable)                     | 0x14     |        4 | Enable jittery clock                         |
| clkmgr.[`MEASURE_CTRL_REGWEN`](#measure_ctrl_regwen)         | 0x18     |        4 | Measurement control write enable             |
| clkmgr.[`MAIN_MEAS_CTRL_EN`](#main_meas_ctrl_en)             | 0x1c     |        4 | Enable for measurement control               |
| clkmgr.[`MAIN_MEAS_CTRL_SHADOWED`](#main_meas_ctrl_shadowed) | 0x20     |        4 | Configuration controls for main measurement. |
| clkmgr.[`RECOV_ERR_CODE`](#recov_err_code)                   | 0x24     |        4 | Recoverable Error code                       |
| clkmgr.[`FATAL_ERR_CODE`](#fatal_err_code)                   | 0x28     |        4 | Error code                                   |

## ALERT_TEST
Alert Test Register
- Offset: `0x0`
- Reset default: `0x0`
- Reset mask: `0x3`

### Fields

```wavejson
{"reg": [{"name": "recov_fault", "bits": 1, "attr": ["wo"], "rotate": -90}, {"name": "fatal_fault", "bits": 1, "attr": ["wo"], "rotate": -90}, {"bits": 30}], "config": {"lanes": 1, "fontsize": 10, "vspace": 130}}
```

|  Bits  |  Type  |  Reset  | Name        | Description                                      |
|:------:|:------:|:-------:|:------------|:-------------------------------------------------|
|  31:2  |        |         |             | Reserved                                         |
|   1    |   wo   |   0x0   | fatal_fault | Write 1 to trigger one alert event of this kind. |
|   0    |   wo   |   0x0   | recov_fault | Write 1 to trigger one alert event of this kind. |

## JITTER_REGWEN
Jitter write enable
- Offset: `0x10`
- Reset default: `0x1`
- Reset mask: `0x1`

### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                            |
|:------:|:------:|:-------:|:-------|:-------------------------------------------------------------------------------------------------------|
|  31:1  |        |         |        | Reserved                                                                                               |
|   0    |  rw0c  |   0x1   | EN     | When 1, the value of [`JITTER_ENABLE`](#jitter_enable) can be changed.  When 0, writes have no effect. |

## JITTER_ENABLE
Enable jittery clock
- Offset: `0x14`
- Reset default: `0x9`
- Reset mask: `0xf`
- Register enable: [`JITTER_REGWEN`](#jitter_regwen)

### Fields

```wavejson
{"reg": [{"name": "VAL", "bits": 4, "attr": ["rw"], "rotate": 0}, {"bits": 28}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                                                                   |
|:------:|:------:|:-------:|:-------|:------------------------------------------------------------------------------------------------------------------------------|
|  31:4  |        |         |        | Reserved                                                                                                                      |
|  3:0   |   rw   |   0x9   | VAL    | Enable jittery clock. A value of kMultiBitBool4False disables the jittery clock, while all other values enable jittery clock. |

## MEASURE_CTRL_REGWEN
Measurement control write enable
- Offset: `0x18`
- Reset default: `0x1`
- Reset mask: `0x1`

### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 1, "attr": ["rw0c"], "rotate": -90}, {"bits": 31}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                                                                              |
|:------:|:------:|:-------:|:-------|:-----------------------------------------------------------------------------------------|
|  31:1  |        |         |        | Reserved                                                                                 |
|   0    |  rw0c  |   0x1   | EN     | When 1, the value of the measurement control can be set.  When 0, writes have no effect. |

## MAIN_MEAS_CTRL_EN
Enable for measurement control
- Offset: `0x1c`
- Reset default: `0x9`
- Reset mask: `0xf`
- Register enable: [`MEASURE_CTRL_REGWEN`](#measure_ctrl_regwen)

### Fields

```wavejson
{"reg": [{"name": "EN", "bits": 4, "attr": ["rw"], "rotate": 0}, {"bits": 28}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                 |
|:------:|:------:|:-------:|:-------|:----------------------------|
|  31:4  |        |         |        | Reserved                    |
|  3:0   |   rw   |   0x9   | EN     | Enable measurement for main |

## MAIN_MEAS_CTRL_SHADOWED
Configuration controls for main measurement.

The threshold fields are made wider than required (by 1 bit) to ensure
there is room to adjust for measurement inaccuracies.
- Offset: `0x20`
- Reset default: `0x17d2afb9`
- Reset mask: `0x3fffffff`
- Register enable: [`MEASURE_CTRL_REGWEN`](#measure_ctrl_regwen)

### Fields

```wavejson
{"reg": [{"name": "HI", "bits": 15, "attr": ["rw"], "rotate": 0}, {"name": "LO", "bits": 15, "attr": ["rw"], "rotate": 0}, {"bits": 2}], "config": {"lanes": 1, "fontsize": 10, "vspace": 80}}
```

|  Bits  |  Type  |  Reset  | Name   | Description                        |
|:------:|:------:|:-------:|:-------|:-----------------------------------|
| 31:30  |        |         |        | Reserved                           |
| 29:15  |   rw   | 0x2fa5  | LO     | Min threshold for main measurement |
|  14:0  |   rw   | 0x2fb9  | HI     | Max threshold for main measurement |

## RECOV_ERR_CODE
Recoverable Error code
- Offset: `0x24`
- Reset default: `0x0`
- Reset mask: `0x7`

### Fields

```wavejson
{"reg": [{"name": "SHADOW_UPDATE_ERR", "bits": 1, "attr": ["rw1c"], "rotate": -90}, {"name": "MAIN_MEASURE_ERR", "bits": 1, "attr": ["rw1c"], "rotate": -90}, {"name": "MAIN_TIMEOUT_ERR", "bits": 1, "attr": ["rw1c"], "rotate": -90}, {"bits": 29}], "config": {"lanes": 1, "fontsize": 10, "vspace": 190}}
```

|  Bits  |  Type  |  Reset  | Name              | Description                                              |
|:------:|:------:|:-------:|:------------------|:---------------------------------------------------------|
|  31:3  |        |         |                   | Reserved                                                 |
|   2    |  rw1c  |   0x0   | MAIN_TIMEOUT_ERR  | main has timed out.                                      |
|   1    |  rw1c  |   0x0   | MAIN_MEASURE_ERR  | main has encountered a measurement error.                |
|   0    |  rw1c  |   0x0   | SHADOW_UPDATE_ERR | One of the shadow registers encountered an update error. |

## FATAL_ERR_CODE
Error code
- Offset: `0x28`
- Reset default: `0x0`
- Reset mask: `0x7`

### Fields

```wavejson
{"reg": [{"name": "REG_INTG", "bits": 1, "attr": ["ro"], "rotate": -90}, {"name": "IDLE_CNT", "bits": 1, "attr": ["ro"], "rotate": -90}, {"name": "SHADOW_STORAGE_ERR", "bits": 1, "attr": ["ro"], "rotate": -90}, {"bits": 29}], "config": {"lanes": 1, "fontsize": 10, "vspace": 200}}
```

|  Bits  |  Type  |  Reset  | Name               | Description                                              |
|:------:|:------:|:-------:|:-------------------|:---------------------------------------------------------|
|  31:3  |        |         |                    | Reserved                                                 |
|   2    |   ro   |   0x0   | SHADOW_STORAGE_ERR | One of the shadow registers encountered a storage error. |
|   1    |   ro   |   0x0   | IDLE_CNT           | One of the idle counts encountered a duplicate error.    |
|   0    |   ro   |   0x0   | REG_INTG           | Register file has experienced a fatal integrity error.   |


<!-- END CMDGEN -->
