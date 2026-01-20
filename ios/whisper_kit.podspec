Pod::Spec.new do |s|
  s.name             = 'whisper_kit'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for offline speech-to-text using whisper.cpp with enhanced audio support.'
  s.description      = <<-DESC
A Flutter plugin for offline speech-to-text using whisper.cpp models implementation with full iOS support, real-time streaming transcription, multi-format audio conversion, and advanced audio preprocessing.
                       DESC
  s.homepage         = 'https://github.com/CodeSagePath/whisper_flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'CodeSagePath' => 'email@example.com' }
  s.source           = { :path => '.' }
  
  # Explicitly list all source files to ensure they're compiled
  s.source_files     = [
    'Classes/**/*.{swift,h,m,mm}',
    'src/main.cpp',
    'src/main.h',
    'src/whisper.cpp/whisper.cpp',
    'src/whisper.cpp/whisper.h',
    'src/whisper.cpp/ggml.c',
    'src/whisper.cpp/ggml.h',
    'src/json/json.hpp'
  ]
  
  s.exclude_files    = 'src/whisper.cpp/examples/**/*'
  
  # Public headers
  s.public_header_files = [
    'Classes/**/*.h',
    'src/**/*.h'
  ]
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GGML_USE_ACCELERATE=1',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'CLANG_CXX_LIBRARY' => 'libc++',
    'OTHER_CPLUSPLUSFLAGS' => '-D__cplusplus=201703L -stdlib=libc++ -O3 -ffast-math',
    'OTHER_CFLAGS' => '-O3 -ffast-math',
    'OTHER_CPLUSPLUSFLAGS[sdk=iphoneos*]' => '-O3 -ffast-math -march=armv8.2-a+fp16',
    'GCC_OPTIMIZATION_LEVEL' => '3'
  }
  s.swift_version = '5.0'

  # Add C++ standard library support
  s.library = 'c++'
  
  # Note: public_header_files already defined above
  s.private_header_files = [
    'Classes/**/*.h',
    'src/**/*.h'
  ]

  # Enhanced framework dependencies
  s.frameworks = 'AVFoundation', 'AudioToolbox', 'Foundation', 'Accelerate'

  # Test files
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'RunnerTests/**/*'
    test_spec.dependency 'Flutter'
  end

  # Enhanced Audio Features Subspec
  s.subspec 'EnhancedAudio' do |enhanced_audio|
    enhanced_audio.source_files = 'Classes/EnhancedAudioManager.swift', 'Classes/StreamingAudioProcessor.swift', 'Classes/AudioFormatConverter.swift', 'Classes/AudioPreprocessor.swift', 'Classes/VoiceActivityDetector.swift', 'Classes/AudioChunker.swift', 'Classes/WhisperKitPlugin+EnhancedAudio.swift'
    enhanced_audio.frameworks = 'AVFoundation', 'AudioToolbox', 'Accelerate'
  end
end