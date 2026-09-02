// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_peppermint/data/top_peppermint.hjson
//                -o hw/top_peppermint/
//
// File is generated based on the following seed configuration:
//   hw/top_peppermint/data/top_peppermint_seed.testing.hjson


package top_peppermint_rnd_cnst_pkg;

  ////////////////////////////////////////////
  // otp_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter otp_ctrl_top_specific_pkg::lfsr_seed_t RndCnstOtpCtrlLfsrSeed = {
    40'h62_5B39DD88
  };

  // Compile-time random permutation for LFSR output
  parameter otp_ctrl_top_specific_pkg::lfsr_perm_t RndCnstOtpCtrlLfsrPerm = {
    240'h2C08_CC3C1219_8606D179_F2535249_449D649A_1425621C_661C2973_8D990743
  };

  // Compile-time random permutation for scrambling key/nonce register reset value
  parameter otp_ctrl_top_specific_pkg::scrmbl_key_init_t RndCnstOtpCtrlScrmblKeyInit = {
    256'h2610A62D_08F074CE_9D1B8C9A_8D23F56F_D2C1A29E_EA9C28B8_81457DDD_29CDA674
  };

  // Compile-time scrambling key
  parameter otp_ctrl_top_specific_pkg::key_t RndCnstOtpCtrlScrmblKey0 = {
    128'h98935387_D84D189E_94D201D4_CA6D258F
  };

  // Compile-time scrambling key
  parameter otp_ctrl_top_specific_pkg::key_t RndCnstOtpCtrlScrmblKey1 = {
    128'h957C6A0C_9C087E73_F96D33DE_76437066
  };

  // Compile-time scrambling key
  parameter otp_ctrl_top_specific_pkg::key_t RndCnstOtpCtrlScrmblKey2 = {
    128'hE6EFAA77_43364FAB_FDADBA18_67AEF4A5
  };

  // Compile-time scrambling key
  parameter otp_ctrl_top_specific_pkg::key_t RndCnstOtpCtrlScrmblKey3 = {
    128'h25D3438C_679BC5E1_E95B1124_9CA35DDE
  };

  // Compile-time digest const
  parameter otp_ctrl_top_specific_pkg::digest_const_t RndCnstOtpCtrlDigestConst0 = {
    128'h32067E17_86B83222_D00054B2_AF120FF8
  };

  // Compile-time digest const
  parameter otp_ctrl_top_specific_pkg::digest_const_t RndCnstOtpCtrlDigestConst1 = {
    128'h86A0B245_4CFA25B2_3B692148_E188C5CA
  };

  // Compile-time digest initial vector
  parameter otp_ctrl_top_specific_pkg::digest_iv_t RndCnstOtpCtrlDigestIV0 = {
    64'h49B7C7CD_1734B80E
  };

  // Compile-time digest initial vector
  parameter otp_ctrl_top_specific_pkg::digest_iv_t RndCnstOtpCtrlDigestIV1 = {
    64'h1AE014CE_FD7DE2CB
  };

  // OTP invalid partition default for buffered partitions
  parameter logic [39807:0] RndCnstOtpCtrlPartInvDefault = {
    704'({
      320'h3CEED93B3B6CC896B7B6E3922FFE2DA700D38096F86129EA6211F144189F2A7AB03EED49FFF8B260,
      384'hE1E06517F6A3B526B41BF4B85845C5FC37D49EA341A17D8A99C88F3FADD328B3CD2C735E8C3CA226C63A76344EE88E7F
    }),
    384'({
      64'h0,
      64'h8EE7450C8953BA06,
      256'h1690F4EEA0429A9907F6A0D9455E4CDB76014CA56A89D17D769B43DF26992CB6
    }),
    1024'({
      64'h0,
      64'hEA03F177B9D9B64C,
      256'h8D7E293E434D01C1B150D304D950FA2779A0F54DD2D67754AD8CDE1875A63C59,
      256'hB35295002D0EC43826651D1B33F50BDFA3F7D6E746DCE271E9C12D014656FC00,
      256'h812D48B252BEE0FD32847ED0AD3F2356797DA6E631F4218164D3643DE3D345A2,
      128'hC1759268D99AC019F24FA152C64C3DF1
    }),
    256'({
      64'h0,
      64'hACBA776A466893F0,
      128'h59FF4A5F90A02CB03F3C46E7BB4276EF
    }),
    384'({
      64'h0,
      64'h8BB12B9C7B0D6F09,
      128'h60E44C4AEE36D14D78041F7ED448B3B,
      128'h906F0ABAE550423FDD1E2420FECF440D
    }),
    128'({
      64'h863E92B607E0A428,
      16'h0, // unallocated space
      8'h69,
      8'h69,
      32'h0
    }),
    576'({
      64'h7A6CA0272FBB2A45,
      256'hC6E3D95995AB6DE517D4F7C755BB438EB2D154DC9C0C59350B4655D84237705A,
      256'hBB1EB796CA0C7967D4A6F20FC026FD6CEBE501567CF66A8296C3D69A4929C3BB
    }),
    8192'({
      8192'h0
    }),
    1088'({
      64'hEA8204499736FABB,
      1024'h0
    }),
    1088'({
      64'hCB6777E20BC19018,
      1024'h0
    }),
    1088'({
      64'h68B264030A7E3075,
      1024'h0
    }),
    1088'({
      64'h5766DFB11EF4A8A1,
      1024'h0
    }),
    1088'({
      64'h3B564D2B3302241F,
      1024'h0
    }),
    1088'({
      64'h91017B0ACAED5533,
      1024'h0
    }),
    1088'({
      64'h4E6B6D9EE5E84694,
      1024'h0
    }),
    1088'({
      64'h38030158241C385F,
      1024'h0
    }),
    11392'({
      64'hDB898548CA1A7F09,
      32'h0, // unallocated space
      6144'h0,
      1280'h0,
      1280'h0,
      1280'h0,
      32'h0,
      1280'h0
    }),
    256'({
      128'h0,
      128'h0
    }),
    4800'({
      64'h393B26042112CE2E,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      512'h0,
      128'h0,
      128'h0,
      224'h0,
      3360'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0
    }),
    2496'({
      64'h684212F41ED500B4,
      32'h0, // unallocated space
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      32'h0,
      64'h0,
      32'h0,
      64'h0,
      32'h0,
      32'h0,
      256'h0,
      32'h0,
      992'h0
    }),
    512'({
      64'hC23B0F9C4778C5DE,
      448'h0
    })
  };

  ////////////////////////////////////////////
  // lc_ctrl
  ////////////////////////////////////////////
  // Diversification value used for all invalid life cycle states.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivInvalid = {
    128'h8F9052C4_E410A914_D67CA904_568DB527
  };

  // Diversification value used for the TEST_UNLOCKED* life cycle states.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivTestUnlocked = {
    128'hEBD7543A_4689BD95_1B183CB8_BF216F28
  };

  // Diversification value used for the DEV life cycle state.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivDev = {
    128'h4E65E1FD_E71DF816_C143C257_5BD40DE3
  };

  // Diversification value used for the PROD/PROD_END life cycle states.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivProduction = {
    128'hE98A45CE_844AE951_AFC88927_5ACE5410
  };

  // Diversification value used for the RMA life cycle state.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivRma = {
    128'h4D8883C1_73C10DFF_AC297AE0_F92F3724
  };

  // Compile-time random bits used for invalid tokens in the token mux
  parameter lc_ctrl_pkg::lc_token_mux_t RndCnstLcCtrlInvalidTokens = {
    256'hBA10B3A0_A91B5288_A3BDCBDF_D488FA37_78EBFB41_9EC7F546_94416348_06D05790,
    256'hDFF6A451_253DDFD7_8E689FD1_6D99B848_90C036F4_E8D7C83B_63ACDA01_9F8D7EDA,
    256'h05D5A9DF_BF0C3F86_70E567E3_D45248FC_C97C0789_01CC4386_3AA87FA6_80492A05,
    256'h4B140BD9_E143DFC4_B6DBEED1_BF90ABFB_15626596_D2EFD423_C911ABC2_4E671612
  };

  ////////////////////////////////////////////
  // aes
  ////////////////////////////////////////////
  // Default seed of the PRNG used for register clearing.
  parameter aes_pkg::clearing_lfsr_seed_t RndCnstAesClearingLfsrSeed = {
    64'h54169BDB_5C2840F0
  };

  // Permutation applied to the LFSR of the PRNG used for clearing.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingLfsrPerm = {
    128'hB1C82DF6_55321733_23DCF9EF_048D3576,
    256'hAA19AC45_A29950D0_0182E935_A446FBFB_BAF381CA_5F14F085_26C227BE_4E91F7B6
  };

  // Permutation applied to the clearing PRNG output for clearing the second share of registers.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingSharePerm = {
    128'h1BF4FE11_5C7A157F_5CAB8B5E_03C4229B,
    256'h9D4A94F7_E0B14461_2C19CCA4_7AF66D6B_D9D2E372_683CC84A_3C02DC96_24EE839D
  };

  // Default seed of the PRNG used for masking.
  parameter aes_pkg::masking_lfsr_seed_t RndCnstAesMaskingLfsrSeed = {
    32'hC05BD6F0,
    256'hC7F6AA48_A202E6F5_EF8F36E1_F62AE9EC_EF2F4A7E_1EC425EE_F897221A_1B2C10A9
  };

  // Permutation applied to the output of the PRNG used for masking.
  parameter aes_pkg::masking_lfsr_perm_t RndCnstAesMaskingLfsrPerm = {
    256'h1875008C_5076883C_8B3A8A17_367F123B_7B1C293E_64440E79_6899639A_0B482C4A,
    256'h676D605D_1627011F_1B098933_2D6F9D52_23057194_39465706_829B3F61_8D0F1087,
    256'h4373697D_6B559196_805C747C_5B225962_6620429F_8E980440_904C7207_02087025,
    256'h30549378_7E2F864F_849C111E_851A1314_03324E2B_97316C0D_3595812A_1D263D37,
    256'h289E926E_65244D5A_49510C83_38211947_2E5E157A_53418F56_45770A6A_58345F4B
  };

  ////////////////////////////////////////////
  // kmac
  ////////////////////////////////////////////
  // Compile-time random data for PRNG default seed
  parameter kmac_pkg::lfsr_seed_t RndCnstKmacLfsrSeed = {
    32'h8EF4200F,
    256'h5081CD00_FD38F1D4_7CC0C610_3A3DA67F_7EF3A4FC_A904A297_A4495B79_2D1FE05A
  };

  // Compile-time random permutation for PRNG output
  parameter kmac_pkg::lfsr_perm_t RndCnstKmacLfsrPerm = {
    64'h0A9A8666_D63AE916,
    256'h72666112_01A5B729_0C6B2EA6_1DD82742_5A441942_64CC431D_54926362_6ADB15B1,
    256'hB7231088_7179CA87_B007BFF1_4A64E9AD_131A8638_94029C72_4A9F5C21_16934A9F,
    256'h086A3595_DFD49E3E_75094BE8_3BC166A7_5AC20618_765A5C0D_C03162B3_80597AAD,
    256'hA474E950_325B3758_554C2D63_D4B78474_23ADD98A_221590B6_38790340_939CB260,
    256'h1F4392CE_80ECF259_423994D8_5EA514A7_B8E40017_E14800E5_B8665AC9_C64B7155,
    256'hE556BB96_40F8624A_4D8B99D1_A802E8ED_08459CF4_07105882_F90C21AE_A5F51C64,
    256'hC21E6C7B_1AA38C3C_09811249_F872605F_0D14E245_715C0B42_A309DC12_2B0442B1,
    256'h13C317A0_CFC6D70A_3EDDC3F9_E92996AC_0E2C9FD0_7C26D982_51C14454_92229134,
    256'h05BB4410_8D9A3397_44DEF58F_5693BDEB_018F5925_1146CA37_D4DE908A_96F1F1BD,
    256'hD8D5412F_47CBB8D1_5C5B66B2_695B29E5_E41A6F93_1B85687B_185F9912_C4369FF4,
    256'hD5F23DA0_2AA961BA_1B432008_46A795E2_2B865601_2EE9C6D4_32792804_E7594D5E,
    256'h676E070C_6C5FE25C_60D2A8AD_80489C78_E0F31630_735AF854_24B959EC_5977382A,
    256'h98BA1E9B_2C14F923_934329A2_08AEC6E9_768BB4CB_05480A2E_AE77970E_B229F640,
    256'h2C2C69E3_88C02BEB_E524AE5F_616BBDFA_4C92E62A_0A6FAFD6_EAA85C47_07A94CA1,
    256'h278A6A69_2806B075_CC661591_6A519045_E2257E94_AF9695A0_9C6DE9EA_0D13AA76,
    256'h187FB1E7_4304ADC7_46AA5CBD_81A1F096_AC110ABB_89B20D53_03CE9C5D_96F1A256,
    256'h3CA4FBCA_9B7BCBF4_019F68E4_083A324F_6CA5010D_0805C2AA_F4065C42_0A3CC1B0,
    256'hC4741622_1130690F_461D8498_BE3F66DB_A983BECB_75C2D588_68D359CA_84EC9328,
    256'h4CC34CF4_B1E83370_B788833B_88B42719_10CD58FE_D77F1A79_D8D062C6_664A6E58,
    256'hE369500E_965D9194_F14D9B9A_491986C7_E004B401_22D37C87_02E9405E_7072C501,
    256'h3C3A8308_D26C46B9_078BD9BD_286588EA_E37B56B1_B5395A1C_81206354_4915949D,
    256'h7B9AE3FE_7C6B5DB5_3CEC576F_0A04422E_104990F8_B480F23E_1240C402_F2B099EF,
    256'hC4EAB6AD_DA92B115_7CED41F1_B60D87D4_FEF16ED3_46A9AC6A_C8C40AA4_89080C49,
    256'h22AE498A_314E28A6_182D57A7_521B001F_748C766C_1B0A22AC_3CB52CCE_D686CD62,
    256'h0264787A_2197557E_7718095B_AC108A07_60E1DAAB_EBF11D55_448598BC_D491CE85,
    256'hCC1C5196_7791660F_D173E893_77C1E055_7B50544A_C6DB5BAE_C4AE0478_1F86886F,
    256'h6467E2D9_0E88CE3C_7EDAB0D3_30440277_4E119DD7_779F65B1_9316F007_EDBF7DD4,
    256'h50F1140F_497B30C9_30884528_34052263_5DC9A168_A215CEA4_0750C0A5_92C92A60,
    256'h5DB44F91_2A463657_A1CD48AF_5B0A58C4_552050CE_88633133_DE33C1C5_756207A3,
    256'hEB536DB3_AF2DFA26_828413C0_C4398DCD_369A55BF_8B95CAC6_7FAAE3D2_4E9CD05C,
    256'h042B876F_8A007214_C8188211_49490AE0_CBA1D3BA_18DC3A85_565618BC_E279C9C7
  };

  // Compile-time random data for PRNG buffer default seed
  parameter kmac_pkg::buffer_lfsr_seed_t RndCnstKmacBufferLfsrSeed = {
    32'h43E42270,
    256'hB728FDD7_B08A5C4D_E78DE5E4_4021DBC5_5FB9AD96_C258A13B_F0BBCC70_48148A64,
    256'h96135F06_54389C91_BED1DA22_E0D5B248_74C4E219_28ED714E_82F58EBB_A15D3AD5,
    256'h4138A5A9_C21C493B_07C2BAB1_73198BDF_F759A49C_B9F6383B_8609A1A3_E9B32ACA
  };

  // Compile-time random permutation for LFSR Message output
  parameter kmac_pkg::msg_perm_t RndCnstKmacMsgPerm = {
    128'hF68E15B4_5986934D_992CC6B3_47ACA37B,
    256'h1729BAA0_B01F73BC_8815A16C_D0FEE605_DF2A5B1D_FF59EF4C_825012B6_0FED4480
  };

  ////////////////////////////////////////////
  // otbn
  ////////////////////////////////////////////
  // Default seed of the PRNG used for URND.
  parameter otbn_pkg::urnd_prng_seed_t RndCnstOtbnUrndPrngSeed = {
    32'h6172C7D0,
    256'h4859AC5C_FEA1A64B_0B0D05AD_4D6E24A4_BC3154C4_8126BFB2_8A4AEFB7_F20AA522
  };

  // Compile-time random permutation for URND permutation in BN MAC.
  parameter otbn_pkg::bn_mac_urnd_perm_t RndCnstOtbnBnMacUrndPerm = {
    256'h4D54849A_1959BB3F_BED1E5C0_24418F5C_CC3CF9A6_22A3ABCD_D06F131F_4BC4DB61,
    256'h4FA46665_50B25685_76B553FD_CFE9749C_3ED3CA80_A2F77577_8AEF2C2E_BC38B871,
    256'h4A9991B9_79687336_09059E0D_BD0188A9_6CFCD6F1_DE2B32EB_C7B77F45_AD6AE483,
    256'h7E17219B_4262BAD5_28E6F058_827CEDEA_0B51A072_3B8C52E0_C2F8B6C1_3198B0C8,
    256'h0767AEE1_23344CAF_4E7AB1A5_6457B443_F3DC201A_5F1CCEC6_EE472908_1EAA8944,
    256'hDAFFDD04_601495CB_2D86405D_3D5B3581_02F212D8_FB5A2A27_D9933346_2FD46EEC,
    256'h70B3033A_E37B6D8D_15F425F6_63C9ACD2_0A0C37DF_18C5556B_1B48A7BF_0F16119F,
    256'h30788E9D_8B69941D_FAD7C387_5E061096_0097F5A8_92493990_A10E26E7_E8E2FE7D
  };

  // Compile-time random reset value for IMem/DMem scrambling key.
  parameter otp_ctrl_pkg::otbn_key_t RndCnstOtbnOtbnKey = {
    128'h99BBDF67_58AD8609_A3095D16_7B010694
  };

  // Compile-time random reset value for IMem/DMem scrambling nonce.
  parameter otp_ctrl_pkg::otbn_nonce_t RndCnstOtbnOtbnNonce = {
    64'h83D2FF71_67A7CBF9
  };

  ////////////////////////////////////////////
  // keymgr_dpe
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter keymgr_pkg::lfsr_seed_t RndCnstKeymgrDpeLfsrSeed = {
    64'h65A0E493_D1EC1430
  };

  // Compile-time random permutation for LFSR output
  parameter keymgr_pkg::lfsr_perm_t RndCnstKeymgrDpeLfsrPerm = {
    128'hE3952708_0C1C3B1B_875FEA2A_4F420B28,
    256'h18091629_906FDB1E_BD1E8D63_613365DA_ED3E1952_DDF1BB69_6C83D7F5_64F23A4C
  };

  // Compile-time random permutation for entropy used in share overriding
  parameter keymgr_pkg::rand_perm_t RndCnstKeymgrDpeRandPerm = {
    160'h362F6E8A_91731A15_FE40DCE1_9495E8D2_B843D47E
  };

  // Compile-time random bits for revision seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeRevisionSeed = {
    256'h12485247_595EC3B8_8DFBABBF_99969CEA_B0691780_2CACD576_2F634C14_B36E8772
  };

  // Compile-time random bits for software generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeSoftOutputSeed = {
    256'hD67F9071_B12DC054_59B825DE_DEFD3862_72A32C2D_B89E62F7_C6C8310D_9E08B3FF
  };

  // Compile-time random bits for hardware generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeHardOutputSeed = {
    256'h3B8390DB_75EF94DA_C87B92FD_FC150C61_56628C4A_A2CEA5DB_A9F3180C_48359728
  };

  // Compile-time random bits for generation seed when aes destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeAesSeed = {
    256'h441317C0_74F52708_CD3DCBBD_DB73DA69_0CC28200_849D8AE1_0F42BF8A_E019CA47
  };

  // Compile-time random bits for generation seed when kmac destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeKmacSeed = {
    256'h440F207C_421E5FCC_4B4E3F26_EFD44F16_0AAB7CFB_11AA1CD3_34D52BE3_3950BFF9
  };

  // Compile-time random bits for generation seed when otbn destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeOtbnSeed = {
    256'hCB53080D_35EFF512_8E07F559_44D5951F_2A38A558_36294463_61D8A4A4_2123E6B0
  };

  // Compile-time random bits for generation seed when no destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeNoneSeed = {
    256'hB81867F5_745F2685_6D0F9C3D_99166E01_EDD5B864_8771A4E5_8512EAA4_6EE7DC26
  };

  ////////////////////////////////////////////
  // csrng
  ////////////////////////////////////////////
  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivNonProduction = {
    128'h9CE2F2F6_E7B95767_F1D20123_AE962A00,
    256'h3E30C2A8_942F27C4_CA21C632_7FB8E7BF_10C9EF8B_9C0DEB24_18423FAF_F41E7B4F
  };

  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivProduction = {
    128'hF4B0E695_53D130A0_407693DE_540219FC,
    256'h8494453A_E7FD82BA_5F8D8FF2_5C89C045_CAFB0541_8DFBE8D7_FCBBEFEC_D0724D14
  };

  ////////////////////////////////////////////
  // sram_ctrl_main
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlMainSramKey = {
    128'h5309F44A_AFF1872F_F7E10939_95149EC3
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlMainSramNonce = {
    128'h1009401F_D157BB84_A905B2C5_F9C73291
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlMainLfsrSeed = {
    64'h6D3F0A01_064F240E
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlMainLfsrPerm = {
    128'hF7101E65_20D01F26_D460425A_D4F230F8,
    256'h12863B75_E373FCEB_9692F9E1_DD24B6A5_7ADA09AC_3219D3BD_FF3BB8D0_A2156468
  };

  ////////////////////////////////////////////
  // rom_ctrl
  ////////////////////////////////////////////
  // Fixed nonce used for address / data scrambling
  parameter bit [63:0] RndCnstRomCtrlScrNonce = {
    64'hA6AC182D_B8D1A221
  };

  // Randomised constant used as a scrambling key for ROM data
  parameter bit [127:0] RndCnstRomCtrlScrKey = {
    128'h875BFFBD_69423ADC_A64DA6E2_1F029892
  };

  ////////////////////////////////////////////
  // rv_core_ibex
  ////////////////////////////////////////////
  // Default seed of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_seed_t RndCnstRvCoreIbexLfsrSeed = {
    32'h3A2586B0
  };

  // Permutation applied to the LFSR of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_perm_t RndCnstRvCoreIbexLfsrPerm = {
    160'h8516275C_DA0D73B4_FF9669D9_2E967EC3_D4044483
  };

  // Default icache scrambling key
  parameter logic [ibex_pkg::SCRAMBLE_KEY_W-1:0] RndCnstRvCoreIbexIbexKey = {
    128'hF1122BEB_15EA2FC0_02AAE3AA_4CDF001F
  };

  // Default icache scrambling nonce
  parameter logic [ibex_pkg::SCRAMBLE_NONCE_W-1:0] RndCnstRvCoreIbexIbexNonce = {
    64'h7A0161DD_19B6BE6C
  };

  ////////////////////////////////////////////
  // alert_handler
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter alert_handler_pkg::lfsr_seed_t RndCnstAlertHandlerLfsrSeed = {
    32'h3FA57AA9
  };

  // Compile-time random permutation for LFSR output
  parameter alert_handler_pkg::lfsr_perm_t RndCnstAlertHandlerLfsrPerm = {
    160'h78D5D2F2_C4BA7E0D_0675A6D8_85CA0D34_45EC1F2E
  };

  ////////////////////////////////////////////
  // sram_ctrl_ret
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlRetSramKey = {
    128'h4275FFBB_34D2938D_19CE5DD7_C307A18B
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlRetSramNonce = {
    128'h42074925_926C7F5F_79B6C1CC_7B7EAC83
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlRetLfsrSeed = {
    64'h1360785B_797FC861
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlRetLfsrPerm = {
    128'hC35A79C8_1AA2155F_613AC1FA_37EB7CC4,
    256'h47173DAB_FB9669F7_D9919F2A_4FD2BA00_80AF8263_3106D479_6D0BCE86_13751203
  };

endpackage : top_peppermint_rnd_cnst_pkg
