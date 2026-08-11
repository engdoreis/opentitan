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
    40'hAD_6538F88A
  };

  // Compile-time random permutation for LFSR output
  parameter otp_ctrl_top_specific_pkg::lfsr_perm_t RndCnstOtpCtrlLfsrPerm = {
    240'h9011_4D3070E5_68624E5E_16DE9C47_2355845F_81259308_A65D40B8_942003E6
  };

  // Compile-time random permutation for scrambling key/nonce register reset value
  parameter otp_ctrl_top_specific_pkg::scrmbl_key_init_t RndCnstOtpCtrlScrmblKeyInit = {
    256'hA2D59D2B_96F58961_344A98A1_0F7A5DBB_327BEE2A_376F9C3B_86EE106E_E6BC3EF8
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
  parameter logic [16319:0] RndCnstOtpCtrlPartInvDefault = {
    704'({
      320'h3CEED93B3B6CC896B7B6E3922FFE2DA700D38096F86129EA6211F144189F2A7AB03EED49FFF8B260,
      384'hE1E06517F6A3B526B41BF4B85845C5FC37D49EA341A17D8A99C88F3FADD328B3CD2C735E8C3CA226C63A76344EE88E7F
    }),
    384'({
      64'h0,
      64'hEA03F177B9D9B64C,
      256'h1690F4EEA0429A9907F6A0D9455E4CDB76014CA56A89D17D769B43DF26992CB6
    }),
    1024'({
      64'h0,
      64'hACBA776A466893F0,
      256'h8D7E293E434D01C1B150D304D950FA2779A0F54DD2D67754AD8CDE1875A63C59,
      256'hB35295002D0EC43826651D1B33F50BDFA3F7D6E746DCE271E9C12D014656FC00,
      256'h812D48B252BEE0FD32847ED0AD3F2356797DA6E631F4218164D3643DE3D345A2,
      128'hC1759268D99AC019F24FA152C64C3DF1
    }),
    256'({
      64'h0,
      64'h8BB12B9C7B0D6F09,
      128'h59FF4A5F90A02CB03F3C46E7BB4276EF
    }),
    384'({
      64'h0,
      64'h863E92B607E0A428,
      128'h60E44C4AEE36D14D78041F7ED448B3B,
      128'h906F0ABAE550423FDD1E2420FECF440D
    }),
    128'({
      64'h7A6CA0272FBB2A45,
      16'h0, // unallocated space
      8'h69,
      8'h69,
      32'h0
    }),
    576'({
      64'hEA8204499736FABB,
      256'hC6E3D95995AB6DE517D4F7C755BB438EB2D154DC9C0C59350B4655D84237705A,
      256'hBB1EB796CA0C7967D4A6F20FC026FD6CEBE501567CF66A8296C3D69A4929C3BB
    }),
    3392'({
      32'h0, // unallocated space
      1120'h0,
      1120'h0,
      1120'h0
    }),
    320'({
      64'hCB6777E20BC19018,
      256'h0
    }),
    320'({
      64'h68B264030A7E3075,
      256'h0
    }),
    320'({
      64'h5766DFB11EF4A8A1,
      256'h0
    }),
    320'({
      64'h3B564D2B3302241F,
      256'h0
    }),
    320'({
      64'h91017B0ACAED5533,
      256'h0
    }),
    320'({
      64'h4E6B6D9EE5E84694,
      256'h0
    }),
    320'({
      64'h38030158241C385F,
      256'h0
    }),
    320'({
      64'hDB898548CA1A7F09,
      256'h0
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
    1344'({
      64'h684212F41ED500B4,
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
      256'h0
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
    128'hFC6D05B9_42C3E576_506CF775_086CFE70
  };

  // Diversification value used for the TEST_UNLOCKED* life cycle states.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivTestUnlocked = {
    128'hCB4DAF4D_B8F49F21_FD6D59E9_D849E862
  };

  // Diversification value used for the DEV life cycle state.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivDev = {
    128'h5B39DD88_0D75E242_7437A238_5FC12BE3
  };

  // Diversification value used for the PROD/PROD_END life cycle states.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivProduction = {
    128'hC5333D77_AEE81229_AD96C8C5_96EDA91A
  };

  // Diversification value used for the RMA life cycle state.
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivRma = {
    128'h2485301A_48907C59_639294C3_3B5F713F
  };

  // Compile-time random bits used for invalid tokens in the token mux
  parameter lc_ctrl_pkg::lc_token_mux_t RndCnstLcCtrlInvalidTokens = {
    256'hDEFA9C76_CA907A26_10A62D08_F074CE9D_1B8C9A8D_23F56FD2_C1A29EEA_9C28B881,
    256'h457DDD29_CDA6748F_9052C4E4_10A914D6_7CA90456_8DB527EB_D7543A46_89BD951B,
    256'h183CB8BF_216F284E_65E1FDE7_1DF816C1_43C2575B_D40DE3E9_8A45CE84_4AE951AF,
    256'hC889275A_CE54104D_8883C173_C10DFFAC_297AE0F9_2F3724BA_10B3A0A9_1B5288A3
  };

  ////////////////////////////////////////////
  // aes
  ////////////////////////////////////////////
  // Default seed of the PRNG used for register clearing.
  parameter aes_pkg::clearing_lfsr_seed_t RndCnstAesClearingLfsrSeed = {
    64'hBDCBDFD4_88FA3778
  };

  // Permutation applied to the LFSR of the PRNG used for clearing.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingLfsrPerm = {
    128'hAE0773A0_5A862E1E_F00844D9_5E27885B,
    256'hFB6EBCAB_0C739E07_0F57C0DC_E372DA66_FC6A33C9_529915D0_1498F654_719D0FBA
  };

  // Permutation applied to the clearing PRNG output for clearing the second share of registers.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingSharePerm = {
    128'hB3174C52_D9DCDCB0_62011BFE_68683A60,
    256'hF58DAC78_FDA790F6_BBC8526C_22683A47_DE40A5E6_CD5E05FD_3C2A1322_35EF4959
  };

  // Default seed of the PRNG used for masking.
  parameter aes_pkg::masking_lfsr_seed_t RndCnstAesMaskingLfsrSeed = {
    32'h38DF9077,
    256'h469A0CAB_69AC24EE_BAB82AFE_4759CFC6_63225C12_D7753AA2_EE916025_DF0BE5C2
  };

  // Permutation applied to the output of the PRNG used for masking.
  parameter aes_pkg::masking_lfsr_perm_t RndCnstAesMaskingLfsrPerm = {
    256'h853E9441_8C815027_2A66306C_3C459187_6E001D75_575C0B53_8E4D8B7E_281F2640,
    256'h383A9033_48180695_5D9A864F_1E7B4644_7D617619_09132E65_34323683_5B140349,
    256'h9F100C23_5F520A3D_2999792B_223B0598_2C1A705E_54081658_89119E12_0F3F2577,
    256'h151B8073_51245582_8A60846F_96477297_2F7A7174_01426817_7F62028D_434E0792,
    256'h784C6356_397C9B93_880D2D04_6A315A1C_676B6D59_21644A37_359C690E_9D204B8F
  };

  ////////////////////////////////////////////
  // kmac
  ////////////////////////////////////////////
  // Compile-time random data for PRNG default seed
  parameter kmac_pkg::lfsr_seed_t RndCnstKmacLfsrSeed = {
    32'hFD4A9945,
    256'hF60E3B08_049D518F_068AEB3C_4DD55DAD_F9D4564C_1C423C86_671D4556_19980F46
  };

  // Compile-time random permutation for PRNG output
  parameter kmac_pkg::lfsr_perm_t RndCnstKmacLfsrPerm = {
    64'hAA1370BA_EF7C6DC8,
    256'h4EF2C64A_96D2EC1D_22CB7656_8E02229E_096E9299_90F030E2_1B320EAF_AC46429B,
    256'h6D65D5C4_56681C05_4D9D369A_F45A3DB7_CFE49E39_238524B4_BB12D1F6_780D9B5B,
    256'hD4BCE94E_0075A82F_1A49A41F_1B848779_E1787F55_EB39741E_499BB800_BA6AC9A1,
    256'hEB2918D7_A037A6A6_59BC0353_0617A60A_AEC13C74_453214B4_3274600D_15649497,
    256'h22D44198_7A8E6161_CC27AC98_D97C4E6C_D70D6475_65B3BD01_151FCA9A_027211B7,
    256'h65F08C13_E01A5337_58447187_9EED1952_A1596497_FCFB7D6C_A7E4FC61_A6C2364F,
    256'h36279906_3C48F0B9_A5065D87_1559355A_CA6BA2F6_3D4CE1EC_417283E0_219718B0,
    256'h65488A03_1C1192AB_6642D719_E5669089_343B6CB0_D6084994_421C5615_7B1207E9,
    256'h1A6F2C36_05475A5B_7AFD0A0A_65705E31_9BA08697_04A8CE7A_7D5B902F_5BE9D6B9,
    256'hAE233009_872B2C48_9627D317_44EB5FC5_F8071053_5E20A90B_7712A638_6C7B5A4B,
    256'hC0D29FEB_4049EE31_6C84921E_B01D88D5_49381CDB_D27DA7A2_B0CAB357_2AF1BAED,
    256'hAC0B04A0_0A2EAF99_8E7C5802_C2C6CF38_8C02BDE3_2BACB1B5_7E709324_B95A26D8,
    256'h9B5D85A9_6DE1C162_C467798A_FC1AE3E5_E56816A6_087C5E22_55086AD3_85E0F6FA,
    256'h581E219A_107F6525_2304AD81_86A9D4BD_13DF2096_D4110ABA_F7070D53_03CE1B1A,
    256'h2343C9CF_659B82FD_00A8B149_113DA9D4_04342017_0AA28419_63C8262A_8BB911D0,
    256'h588844C1_A43D1892_1262F8FD_AB6C560E_C22DD70A_C66B35A6_6A48CA13_2E533D2C,
    256'h6C4CDB8E_4320CEE2_2D09BC5C_B356E18B_9C469C3A_3418BC29_92931638_523203AD,
    256'h2194F14D_9B99C119_18C7E005_EF0120C3_7C87014A_002C4339_60D09E67_80283076,
    256'h599C446C_204DB1C2_331AEAC0_B1367018_740DE141_A85DF098_A49D28CF_685A2278,
    256'h551272F8_391D479C_24B40A81_224A940B_27984E71_59FC6AC1_6B8FF969_AD76D4F3,
    256'hB15DBFE5_F108B841_2423E276_03C8F40C_402F28D9_16D64EAF_DA51A92B_31CC06DB,
    256'h1F1B60D8_7D4FEBA6_ED346A9A_C6AC8C40_B0F89303_A5522AE4_989A94E2_8A3F82D5,
    256'h79E921A7_41F748C7_66C1B0A2_2AB9CB52_CCED686A_A6202647_87A21975_57ED5180,
    256'h95B64108_A0760E1D_AA329C11_D5544859_8BCD491F_005CC1C5_19677916_60FD173E,
    256'hB0C77C1E_C5D7B505_44A3AB75_B92B811E_07E1A21B_D919F8B6_43A2338E_F7ADAA04,
    256'hCC11009D_D3846775_DDE7D96C_64C5BB6A_FE6FF185_17054503_D25EA932_4C2C594A,
    256'h0D014898_D772685B_EC8573A9_01D43029_64B24A98_174F912A_463657A1_CD486C29,
    256'h63115481_433A218C_BACF78CE_E015D588_1E8FAD4D_B6CEBCA2_6828413C_0C4398DC,
    256'hD369A55B_60B95CAC_67FAAE3D_24E9CD05_0AF0EA00_72C78818_82114949_0AE0CBA1,
    256'hD3BA18DC_3A855656_18BCE279_C9C72D16_DA468AA9_2937EE99_3A1F3508_808EC3C9,
    256'h797D4445_119A6124_D6F87681_C7E25586_977D1A32_10157DC9_180D4345_63A14DD3
  };

  // Compile-time random data for PRNG buffer default seed
  parameter kmac_pkg::buffer_lfsr_seed_t RndCnstKmacBufferLfsrSeed = {
    32'hE5A7CBFB,
    256'h991D04E5_606487D4_83076E01_67A8C32F_CDB63186_1C7B35E8_764001C6_FF68E40F,
    256'hC9E5F5D0_60464B9C_CA4196C5_57CEA57E_4D976667_EAD93240_73161DE6_85D85F59,
    256'h2BADA0BB_C98A3E61_201A2836_DCA33964_F4209EB0_A6207060_617324AA_41418492
  };

  // Compile-time random permutation for LFSR Message output
  parameter kmac_pkg::msg_perm_t RndCnstKmacMsgPerm = {
    128'hA41446D6_A68D3268_186DD3E8_55487E93,
    256'hC127EEB1_F900B0B6_6784B139_696EEB38_F75E2B0A_B5C210C1_ED3F16FC_9FF490D3
  };

  ////////////////////////////////////////////
  // otbn
  ////////////////////////////////////////////
  // Default seed of the PRNG used for URND.
  parameter otbn_pkg::urnd_prng_seed_t RndCnstOtbnUrndPrngSeed = {
    32'hBAB17319,
    256'h8BDFF759_A49CB9F6_383B8609_A1A3E9B3_2ACA014A_51ED3D61_AC10EA42_25224CEE
  };

  // Compile-time random permutation for URND permutation in BN MAC.
  parameter otbn_pkg::bn_mac_urnd_perm_t RndCnstOtbnBnMacUrndPerm = {
    256'h42503D45_67CCBB6C_F303604F_27A95691_35CD8DD4_D65746F9_9C2CC29F_58D1CE83,
    256'hDC3FB1CB_3C412A8C_84AE3362_E6657053_343A3B4C_47E451B0_99795BF7_E7A012B8,
    256'h322B7521_F507FE68_E0D7C3ED_087114C5_8F5F44AA_BE3EBA02_D3D29AEA_1CF0DA20,
    256'h2E1EC91A_40807AD8_B9A72DF4_74DFCFBC_19FD1788_85ECEB2F_38C0B5FC_984E6466,
    256'h7B6D1525_B36389FA_EE371855_6B1BD00F_C4113078_8E8B6994_1DA8875E_E810F800,
    256'h97A39249_DB90C80E_C77D22A5_0A4A8A26_E3DD31A4_246E4DAD_050DCAF1_A6A15CAC,
    256'hE9487261_16E17CAF_BD6A0BC6_1F9573B4_C128A2D5_9B52939E_09FB43E2_F254FF13,
    256'hD9043981_767E5AE5_0659B786_6F360CAB_EF4BB6F6_825D7F29_96B2DE77_01239DBF
  };

  // Compile-time random reset value for IMem/DMem scrambling key.
  parameter otp_ctrl_pkg::otbn_key_t RndCnstOtbnOtbnKey = {
    128'hD16A99DB_9D0330B3_1BAF54A8_940B126D
  };

  // Compile-time random reset value for IMem/DMem scrambling nonce.
  parameter otp_ctrl_pkg::otbn_nonce_t RndCnstOtbnOtbnNonce = {
    64'hE072D494_EF5120FB
  };

  ////////////////////////////////////////////
  // keymgr_dpe
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter keymgr_pkg::lfsr_seed_t RndCnstKeymgrDpeLfsrSeed = {
    64'h35DA1E6D_559A25E0
  };

  // Compile-time random permutation for LFSR output
  parameter keymgr_pkg::lfsr_perm_t RndCnstKeymgrDpeLfsrPerm = {
    128'hA199948B_9EE472A6_812CCAC3_188A51C4,
    256'hE7E31009_CAE935CD_8180B587_F4B4DBD5_73772F1B_F9E25094_75ADDCFC_05E2CBAF
  };

  // Compile-time random permutation for entropy used in share overriding
  parameter keymgr_pkg::rand_perm_t RndCnstKeymgrDpeRandPerm = {
    160'h8DDBE992_C7EE7654_A1433731_5FB1D096_80F12C34
  };

  // Compile-time random bits for revision seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeRevisionSeed = {
    256'hD94AC694_D9853D85_8477C8F5_A764EE90_111A60E2_3455474B_F57D68DA_8327A8FD
  };

  // Compile-time random bits for software generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeSoftOutputSeed = {
    256'h2DD2EC49_940D52B7_5F45EAD9_265B4712_DC9BD57F_6CF7A2E2_B5B64795_DE1BFCE9
  };

  // Compile-time random bits for hardware generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeHardOutputSeed = {
    256'h71134323_3F0CF41D_AD39273D_EA563D41_782A4C52_8552260E_413BB7D3_F9CCF9D8
  };

  // Compile-time random bits for generation seed when aes destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeAesSeed = {
    256'hD3123B14_4B65364F_45239B17_12485247_595EC3B8_8DFBABBF_99969CEA_B0691780
  };

  // Compile-time random bits for generation seed when kmac destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeKmacSeed = {
    256'h2CACD576_2F634C14_B36E8772_D67F9071_B12DC054_59B825DE_DEFD3862_72A32C2D
  };

  // Compile-time random bits for generation seed when otbn destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeOtbnSeed = {
    256'hB89E62F7_C6C8310D_9E08B3FF_3B8390DB_75EF94DA_C87B92FD_FC150C61_56628C4A
  };

  // Compile-time random bits for generation seed when no destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrDpeNoneSeed = {
    256'hA2CEA5DB_A9F3180C_48359728_441317C0_74F52708_CD3DCBBD_DB73DA69_0CC28200
  };

  ////////////////////////////////////////////
  // csrng
  ////////////////////////////////////////////
  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivNonProduction = {
    128'h849D8AE1_0F42BF8A_E019CA47_440F207C,
    256'h421E5FCC_4B4E3F26_EFD44F16_0AAB7CFB_11AA1CD3_34D52BE3_3950BFF9_CB53080D
  };

  // Compile-time random bits for csrng state group diversification value
  parameter csrng_pkg::cs_keymgr_div_t RndCnstCsrngCsKeymgrDivProduction = {
    128'h35EFF512_8E07F559_44D5951F_2A38A558,
    256'h36294463_61D8A4A4_2123E6B0_B81867F5_745F2685_6D0F9C3D_99166E01_EDD5B864
  };

  ////////////////////////////////////////////
  // sram_ctrl_main
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlMainSramKey = {
    128'h8771A4E5_8512EAA4_6EE7DC26_9CE2F2F6
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlMainSramNonce = {
    128'hE7B95767_F1D20123_AE962A00_3E30C2A8
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlMainLfsrSeed = {
    64'h942F27C4_CA21C632
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlMainLfsrPerm = {
    128'h6FCC7A14_DE3EA77F_D25A6EF3_04A0B68D,
    256'hA66D2187_30ABD2D7_80E461D4_0564774A_0C525B13_787ACF40_62439E2C_84BF9B9F
  };

  ////////////////////////////////////////////
  // rom_ctrl
  ////////////////////////////////////////////
  // Fixed nonce used for address / data scrambling
  parameter bit [63:0] RndCnstRomCtrlScrNonce = {
    64'h57BB84A9_05B2C5F9
  };

  // Randomised constant used as a scrambling key for ROM data
  parameter bit [127:0] RndCnstRomCtrlScrKey = {
    128'hC732916D_3F0A0106_4F240EA0_465A1689
  };

  ////////////////////////////////////////////
  // rv_core_ibex
  ////////////////////////////////////////////
  // Default seed of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_seed_t RndCnstRvCoreIbexLfsrSeed = {
    32'h0A37BB88
  };

  // Permutation applied to the LFSR of the PRNG used for random instructions.
  parameter ibex_pkg::lfsr_perm_t RndCnstRvCoreIbexLfsrPerm = {
    160'hCB1BC710_1E41623A_48EBAE3A_A0FF5BB1_A134DDE2
  };

  // Default icache scrambling key
  parameter logic [ibex_pkg::SCRAMBLE_KEY_W-1:0] RndCnstRvCoreIbexIbexKey = {
    128'h597635D3_EFFEF7C2_50098FB9_64BE41D6
  };

  // Default icache scrambling nonce
  parameter logic [ibex_pkg::SCRAMBLE_NONCE_W-1:0] RndCnstRvCoreIbexIbexNonce = {
    64'h92B97C16_69F1994B
  };

  ////////////////////////////////////////////
  // alert_handler
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter alert_handler_pkg::lfsr_seed_t RndCnstAlertHandlerLfsrSeed = {
    32'h9663DFCC
  };

  // Compile-time random permutation for LFSR output
  parameter alert_handler_pkg::lfsr_perm_t RndCnstAlertHandlerLfsrPerm = {
    160'hBE447C37_400B3F38_9972ED4A_3A121BF3_D2E5591C
  };

  ////////////////////////////////////////////
  // sram_ctrl_ret
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlRetSramKey = {
    128'h1B208846_04567BC0_249E2D8A_B794A763
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlRetSramNonce = {
    128'h3D9C6ECF_883C940F_9C5210B3_C5863384
  };

  // Compile-time random bits for initial LFSR seed
  parameter sram_ctrl_pkg::lfsr_seed_t RndCnstSramCtrlRetLfsrSeed = {
    64'h02BDF112_2BEB15EA
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlRetLfsrPerm = {
    128'h98DF8A3A_09F25482_5FB31136_FC3054AD,
    256'h27798B46_68942424_5F345685_A32316E7_3AD693DB_BED198ED_E1FDDD3F_38A80C0B
  };

endpackage : top_peppermint_rnd_cnst_pkg
