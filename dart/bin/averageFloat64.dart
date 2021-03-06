/*
  Copyright (C) 2013 John McCutchan <john@johnmccutchan.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/

library vector_math_matrix_bench;

import 'dart:typed_data';
import 'package:vector_math/vector_math_operations.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'benchmark_contrast.dart';

class NonSIMDAverageBenchmark extends BenchmarkBase {
  const NonSIMDAverageBenchmark() : super("NonSIMDAverage");
  final Float64List A = new Float64List(1000);

  static void main() {
    new NonSIMDAverageBenchmark().report();
  }

  void setup() {
    for (var j = 0; j < A.length; j++) A[j] = j + 0.1;
  }

  void run() {
    double sum = 0;
    for (var j = 0; j < A.length; j++) sum += A[j];
    return sum/A.length;
  }
}

class SIMDAverageBenchmark extends BenchmarkBase {
  const SIMDAverageBenchmark() : super("SIMDAverage");
  final Float64x2List B = new Float64x2List(500);   // A.length / 2

  static void main() {
    new SIMDAverageBenchmark().report();
  }

  void setup() {
    for (var j = 0; j < B.length; j++) {
      B[j] = new Float64x2(j * 2 + 0.1, j * 2 + 1.1);
    }
  }

  void run() {
    Float64x2 sum = new Float64x2.zero();
    for (var j = 0; j < B.length; j++) sum += B[j];
    return (sum.x + sum.y) / (B.length * 2);
  }
}

class AverageFloat64Benchmark {
  static Object create() {
    return new BenchmarkContrast("AverageFloat64",
                                 new NonSIMDAverageBenchmark(),
                                 new SIMDAverageBenchmark());
  }
}
